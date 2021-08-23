//
//  ChartCellModel.swift
//  ChartCellModel
//
//  Created by Ariane Hine on 23/08/2021.
//

import Foundation
import SwiftUI
//The data structure which is used for the Doughnut Chart data samples
struct ChartCellModel: Identifiable {
    let id = UUID()
    let color: Color
    let value: CGFloat
    let name: String
}
