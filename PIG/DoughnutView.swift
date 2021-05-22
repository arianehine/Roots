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
                PieChart(dataModel: dataModel, onTap: onTap)
                InnerCircle(ratio: 1/3).foregroundColor(.white)
            }
    }
}

struct PieChart: View {
    @State private var selectedCell: UUID = UUID()
    
    
    let dataModel: ChartDataModel
    let onTap: (ChartCellModel?) -> ()
    var body: some View {
            ZStack {
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
    @State var people = [UserData]()
    @Binding var reports: [Report]
    @Binding var originalReports: [Report]
    var body: some View {
            ScrollView {
                VStack {
                    HStack(spacing: 20) {
                        PieChart(dataModel: ChartDataModel.init(dataModel: sample), onTap: {
                            dataModel in
                            if let dataModel = dataModel {
                                self.selectedPie = "Topic: \(dataModel.name)\nkg Co2: \(dataModel.value)"
                            } else {
                                self.selectedPie = ""
                            }
                        })
                            .frame(width: 150, height: 150, alignment: .center)
                            .padding()
                        Text(selectedPie)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                        Spacer()
                        
                    }
                    HStack(spacing: 20) {
                        DonutChart(dataModel: ChartDataModel.init(dataModel: sample), onTap: {
                            dataModel in
                            if let dataModel = dataModel {
                                self.selectedDonut = "Subject: \(dataModel.name)\nPointes: \(dataModel.value)"
                            } else {
                                self.selectedDonut = ""
                            }
                        })
                        .frame(width: 150, height: 150, alignment: .center)
                        .padding()
                        Text(selectedDonut)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        ForEach(sample) { dataSet in
                            VStack {
                                Circle().foregroundColor(dataSet.color)
                                Text(dataSet.name).font(.footnote)
                            }
                        }
                    }
                }.onAppear{ people = statsController.convertCSVIntoArray();
                    let user = statsController.findUserData(people: people, ID: ID);
                        self.reports = statsController.convertToReports(users: user);
                        self.originalReports = statsController.convertToReports(users: user);
                        print(reports);};
                
                ToggleView(selected: $selection).onChange(of: selection, perform: { value in
                    reports = statsController.updateReports(value: value, reports: originalReports, statsController: statsController)
                });
            }
       
    }
}

struct PieChart_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ChartCellModel: Identifiable {
    let id = UUID()
    let color: Color
    let value: CGFloat
    let name: String
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


let sample = [ ChartCellModel(color: Color.red, value: 123, name: "Transport"),
               ChartCellModel(color: Color.yellow, value: 233, name: "Household"),
               ChartCellModel(color: Color.pink, value: 73, name: "Fashion"),
               ChartCellModel(color: Color.blue, value: 731, name: "Health"),
               ChartCellModel(color: Color.green, value: 51, name: "Food")]


//struct DoughnutView_Previews: PreviewProvider {
//    static var previews: some View {
//        DoughnutView(ID: "8")
//    }
//}
