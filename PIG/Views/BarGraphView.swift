//
//  BarGraphView.swift
//  PIG
//
//  Created by ariane hine on 18/05/2021.
//

import SwiftUI

import FirebaseAuth

struct BarGraphView: View {
    @Binding var selection: String
    @State var divisor = 0;
    @State var barWidth = 0;
    @Binding var reports: [Report]
    @Binding var originalReports: [Report]
    @EnvironmentObject var statsController: StatsDataController
    var body: some View {
        
        VStack {
                    
                    HStack(alignment: .lastTextBaseline) {
                        if !(reports.count == 0 || selection == "") {
                            let maxValue =  reports.map { ($0.average / Double($0.numReportsComposingReport))}.max()
                            let divisor = (maxValue ?? 500) / 5.0
                            let barWidth = 300 / reports.count
                        ForEach(self.reports, id: \.year) { report in
                            BarView(report: report, divisor: divisor, barWidth: CGFloat(barWidth)) //need to keep a dynamic list of bars/reports
                        }
                            
                        }else{
                            Text("No data for this time period").font(.title)
                        }
                        
                    }
                    ToggleView(selected: $selection).onChange(of: selection, perform: { value in
                        reports = statsController.updateReports(value: value, reports: originalReports, statsController: statsController)
                    });
                    
                    
        }.onAppear(perform: initFunc
    
          
                
    )
        }
func initFunc(){
    if (selection != "") {

    reports = statsController.updateReports(value: selection, reports: originalReports, statsController: statsController)
    }
            }
}

struct BarView: View {
    
    @State var report: Report
    let divisor: Double
    let barWidth: CGFloat
    
    var body: some View {
        
        let value = (report.average / Double(report.numReportsComposingReport)) / divisor
        let yValue = Swift.min(value * 20, divisor)
        
        return VStack {
            Text(String(format: "%.2f kg Co2 average",(report.average / Double(report.numReportsComposingReport)))).font(/*@START_MENU_TOKEN@*/.caption/*@END_MENU_TOKEN@*/).padding(.bottom, 50)
            NavigationLink(destination: NumberEarthsView(ID: Auth.auth().currentUser!.uid,  report: $report)){
         
                Chimney().foregroundColor((report.average / Double(report.numReportsComposingReport)) < 2200 ? Color.green : Color.red)
                .frame(width: barWidth, height: CGFloat(abs(yValue)))
            
          
            }
            Text(report.year)
        }
        
        
    }
    
}

//struct BarGraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        BarGraphView(reports: Report.all())
//    }
//}

