//
//  BarGraphView.swift
//  PIG
//
//  Created by ariane hine on 18/05/2021.
//

import SwiftUI

import SwiftUI

struct BarGraphView: View {
    
    let reports: [Report]
    
    var body: some View {
       
        VStack {
            
            HStack(alignment: .lastTextBaseline) {
                
                ForEach(self.reports, id: \.year) { report in
                    BarView(report: report)
                }
                
            }
            
        }
        
    }
}


struct BarView: View {
    
    let report: Report
    
    var body: some View {
        
        let value = report.average / 500
        let yValue = Swift.min(value * 20, 500)
        
        return VStack {
            
            Text(String(format: "$%.2f",report.average))
            Rectangle()
                .fill(report.average < 2200 ? Color.green : Color.red)
                .frame(width: 100, height: CGFloat(yValue))
            
            Text(report.year)
            
        }
        
    }
    
}


struct BarGraphView_Previews: PreviewProvider {
    static var previews: some View {
        BarGraphView(reports: Report.all())
    }
}

struct Report{
    let year: String;
    let average: Double;
}

extension Report {
    static func all() -> [Report]{
        return [
        
            Report(year: "2001", average: 900.0),
            Report(year: "2003", average: 500.0),
            Report(year: "2005", average: 1000.0),
        ]
    }
}

