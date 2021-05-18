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
        
        let value = report.revenue / 500
        let yValue = Swift.min(value * 20, 500)
        
        return VStack {
            
            Text(String(format: "$%.2f",report.revenue))
            Rectangle()
                .fill(report.revenue > 5000 ? Color.green : Color.red)
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
    let revenue: Double;
}

extension Report {
    static func all() -> [Report]{
        return [
        
            Report(year: "2001", revenue: 900.0),
            Report(year: "2003", revenue: 500.0),
            Report(year: "2005", revenue: 1000.0),
        ]
    }
}

