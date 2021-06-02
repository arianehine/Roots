//
//  DoughnutView.swift
//  PIG
//
//  Created by ariane hine on 21/05/2021.
//
// adapted from https://prafullkumar77.medium.com/how-to-make-pie-and-donut-chart-using-swiftui-12e8ef916ce5
import SwiftUI

//struct DoughnutView: View {
//    @State var selection = "";
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}

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
            InnerCircle(ratio: 1/3).foregroundColor(.white)
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
    let ID: String
    //    @Binding var reports: [Report]
    //    @Binding var originalReports: [Report]
    @EnvironmentObject var statsController: StatsDataController
    @State var selection = "";
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
//                HStack(spacing: 20) {
//                    PieChart(dataModel: ChartDataModel.init(dataModel: sample), onTap: {
//                        dataModel in
//                        if let dataModel = dataModel {
//                            self.selectedPie = "Topic: \(dataModel.name)\nkg Co2: \(dataModel.value)"
//                        } else {
//                            self.selectedPie = ""
//                        }
//                    })
//                    .frame(width: 150, height: 150, alignment: .center)
//                    .padding()
//                    Text(selectedPie)
//                        .font(.footnote)
//                        .multilineTextAlignment(.leading)
//                    Spacer()
//
//                }
                
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
                
                print(statsController.originalPeople.count)
                
                if(statsController.originalPeople.count != 0){
                    print("it was not 0")
                    people = statsController.originalPeople
                   
                }
                   
                  else{
                    print("it was 0")
                    people = originalPeople
                   }
        
                print("yo")
                let user = statsController.findUserData(people: people, ID: ID);
//                self.reports = statsController.convertToReports(users: user);
                self.originalReports = statsController.convertToReports(users: user);
                print(reports);};
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
            });
           
            
            
        }.frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).navigationBarHidden(true)
        }
        
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
//struct PieChart_Previews: PreviewProvider {
//    var statsController: StatsDataController
//    static var previews: some View {
//        ContentView(statsController: statsController)
//    }
//}

struct ChartCellModel: Identifiable {
    let id = UUID()
    let color: Color
    let value: CGFloat
    let name: String
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

final class ChartDataModel: ObservableObject {
    var chartCellModel: [ChartCellModel]
    var startingAngle = Angle(degrees: 0)
    private var lastBarEndAngle = Angle(degrees: 0)
    
    
    init(dataModel: [ChartCellModel]) {
        chartCellModel = dataModel
    }
    
    var totalValue: CGFloat {
        chartCellModel.reduce(CGFloat(0)) { (result, data) -> CGFloat in
            result + data.value
        }
    }
    
    func angle(for value: CGFloat) -> Angle {
        if startingAngle != lastBarEndAngle {
            startingAngle = lastBarEndAngle
        }
        lastBarEndAngle += Angle(degrees: Double(value / totalValue) * 360 )
        print(lastBarEndAngle.degrees)
        return lastBarEndAngle
    }
}


//let sample = [ ChartCellModel(color: Color.red, value: 123, name: "Transport"),
//               ChartCellModel(color: Color.yellow, value: 233, name: "Household"),
//               ChartCellModel(color: Color.pink, value: 73, name: "Fashion"),
//               ChartCellModel(color: Color.blue, value: 731, name: "Health"),
//               ChartCellModel(color: Color.green, value: 51, name: "Food")]


//struct DoughnutView_Previews: PreviewProvider {
//    static var previews: some View {
//        DoughnutView(ID: "8")
//    }
//}
