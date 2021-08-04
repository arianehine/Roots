//
//  DoughnutView.swift
//  PIG
//
//  Created by ariane hine on 21/05/2021.
//
// adapted from https://prafullkumar77.medium.com/how-to-make-pie-and-donut-chart-using-swiftui-12e8ef916ce5
import SwiftUI

struct PieChartCell: Shape {
    let startAngle: Angle
    let endAngle: Angle
    func path(in rect: CGRect) -> Path {
        let center = CGPoint.init(x: (rect.origin.x + rect.width)/2, y: (rect.origin.y + rect.height)/2)
        let radii = min(center.x, center.y)
        let path = Path { p in
            p.addArc(center: center,
                     radius: radii,
                     startAngle: startAngle,
                     endAngle: endAngle,
                     clockwise: true)
            p.addLine(to: center)
        }
        return path
    }
}

struct InnerCircle: Shape {
    let ratio: CGFloat
    func path(in rect: CGRect) -> Path {
        let center = CGPoint.init(x: (rect.origin.x + rect.width)/2, y: (rect.origin.y + rect.height)/2)
        let radii = min(center.x, center.y) * ratio
        let path = Path { p in
            p.addArc(center: center,
                     radius: radii,
                     startAngle: Angle(degrees: 0),
                     endAngle: Angle(degrees: 360),
                     clockwise: true)
            p.addLine(to: center)
        }
        return path
    }
}

struct DonutChart: View {
    @State private var selectedCell: UUID = UUID()
    
    let dataModel: ChartDataModel
    let onTap: (ChartCellModel?) -> ()
    
    var body: some View {
        ZStack {
            if !(dataModel.chartCellModel.count==0) {
            PieChart(dataModel: dataModel, onTap: onTap)
                InnerCircle(ratio: 1/3).foregroundColor(.white).colorInvert()
            }
        }
    }
}

struct PieChart: View {
    @State private var selectedCell: UUID = UUID()
    
    
    let dataModel: ChartDataModel
    let onTap: (ChartCellModel?) -> ()
    var body: some View {
        ZStack {
            if !(dataModel.chartCellModel.count==0) {
                ForEach(dataModel.chartCellModel) { dataSet in
                    PieChartCell(startAngle: self.dataModel.angle(for: dataSet.value), endAngle: self.dataModel.startingAngle)
                        .foregroundColor(dataSet.color)
                        .onTapGesture {
                            withAnimation {
                                if self.selectedCell == dataSet.id {
                                    self.onTap(nil)
                                    self.selectedCell = UUID()
                                } else {
                                    self.selectedCell = dataSet.id
                                    self.onTap(dataSet)
                                }
                            }
                            
                        }.scaleEffect((self.selectedCell == dataSet.id) ? 1.05 : 1.0)
                }
            }else{
                Text("No data for this time period").font(.title)
                }
        }
        
    }
    
}


struct DoughnutView: View {
    @Binding var ID: String
    @EnvironmentObject var viewModel: AppViewModel
    @EnvironmentObject var statsController: StatsDataController
    @State var selection: String
    @State var selectedPie: String = ""
    @State var selectedDonut: String = ""
    @State var worstArea: String = ""
    @State var people = [UserData]()
    @State var sample = [ChartCellModel]()
    @Binding var reports: [Report]
    @Binding var originalReports: [Report]
    @State var originalPeople : [UserData]
    var body: some View {
        NavigationView{
        ScrollView {
        
            VStack(alignment: .center) {
                if !(reports.count == 0){

                
                HStack {
                        Spacer()
                    DonutChart(dataModel: ChartDataModel.init(dataModel: sample), onTap: {
                        dataModel in
                        if let dataModel = dataModel {
                            self.selectedDonut = "Topic: \(dataModel.name)\n kg Co2: " +  String(format: "%.2f", dataModel.value)
                        } else {
                            self.selectedDonut = ""
                        }
                    })
                    .frame(width: 300, height: 300, alignment: .center)
                    .padding()
                    Text(selectedDonut)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    }.frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                   
                Spacer()
                HStack {
                    ForEach(sample) { dataSet in
                        VStack {
                            Circle().foregroundColor(dataSet.color)
                            Text(dataSet.name).font(.footnote)
                        }
                    }
                }.frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                 
                } else {
                                Text("No data found for this time period")
                            }
            
            }.frame(minHeight: 350, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .onAppear{
                
   
                if(statsController.fbLogic.userData.count != 0){
                
                    people = statsController.fbLogic.userData
                    print("herey", people.count)
               
            }
               
   
                  else{

                    people = originalPeople
                   }
        

                let user = statsController.findUserData(people: people, ID: viewModel.footprint);
                
//                self.reports = statsController.convertToReports(users: user);
                self.originalReports = statsController.convertToReports(users: user);
                }
            Spacer()
            if !(reports.count==0){

                 NavigationLink(destination: ImproveView(statsController: statsController, worstArea: $worstArea, reports: $reports, sample: $sample, timePeriod: $selection)) {
                    Text("Your worst area is \(worstArea)").foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/).underline()
                }.environmentObject(statsController).buttonStyle(PlainButtonStyle())
                

            }
            Spacer()
         
            ToggleView(selected: $selection).onChange(of: selection, perform: { value in
                reports = statsController.updateReports(value: value, reports: originalReports, statsController: statsController);
                sample = convertRecordsToSamples(records: reports);
                worstArea = updateWorstArea(samples: sample);
            }).font(.subheadline);
           
            
            
        }.onChange(of: viewModel.footprint){ value in
            self.ID = value
            self.ID = value
            let user = statsController.findUserData(people: people, ID: ID);
         
           // self.reports = statsController.convertToReports(users: user);
            self.originalReports = statsController.convertToReports(users: user);
            
        }.onChange(of: self.statsController.fbLogic.userData) {value in
            
            print("userdata change")
            self.originalPeople = statsController.originalPeople
            self.people = statsController.fbLogic.userData
            //update originalreports
            let user = statsController.findUserData(people: originalPeople, ID: viewModel.footprint);
            
            self.originalReports = statsController.convertToReports(users: user);
            
            reports = statsController.updateReports(value: selection, reports: originalReports, statsController: statsController);
          
            sample = convertRecordsToSamples(records: reports);
            worstArea = updateWorstArea(samples: sample);
        }.frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).navigationBarHidden(true)
        }.preferredColorScheme(.dark)
        
    }
}

func updateWorstArea(samples: [ChartCellModel]) -> String{
    
    var worst = ""
    var max: CGFloat = 0;
    for sample in samples{
        if sample.value > max{
            max = sample.value
            worst = sample.name
        }
        
    }
    return worst;
    
}


func convertRecordsToSamples(records: [Report]) -> [ChartCellModel]{
    var transportTotal: CGFloat = 0.0
    var householdTotal: CGFloat = 0.0
    var clothingTotal: CGFloat = 0.0
    var healtTotalh: CGFloat = 0.0
    var foodTotal: CGFloat = 0.0
    
    for record in records{
        transportTotal += CGFloat(record.transport)
        householdTotal += CGFloat(record.household)
        clothingTotal += CGFloat(record.clothing)
        healtTotalh += CGFloat(record.health)
        foodTotal += CGFloat(record.food)
    }
    
    
    var returnSamples = [ChartCellModel]()
    returnSamples.append(ChartCellModel(color: Color.red, value: transportTotal, name: "Transport"))
    returnSamples.append(ChartCellModel(color: Color.yellow, value: householdTotal, name: "Household"))
    returnSamples.append(ChartCellModel(color: Color.purple, value: clothingTotal, name: "Fashion"))
    returnSamples.append(ChartCellModel(color: Color.blue, value: healtTotalh, name: "Health"))
    returnSamples.append(ChartCellModel(color: Color.green, value: foodTotal, name: "Food"))
    
    return returnSamples;
}


