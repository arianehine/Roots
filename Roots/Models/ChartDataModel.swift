//
//  ChartDataModel.swift
//  ChartDataModel
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
import SwiftUI
//Class storing the model for the chart data which is displayed within the Doughnut Chart
//Adapted from https://prafullkumar77.medium.com/how-to-make-pie-and-donut-chart-using-swiftui-12e8ef916ce5
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
        
        return lastBarEndAngle
    }
}


