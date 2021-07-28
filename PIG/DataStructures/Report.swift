//
//  Report.swift
//  Report
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
import SwiftUI

struct Report: Hashable{
    var year: String;
    let average: Double;
    var date: Date;
    let transport: Double
    let household: Double
    let clothing: Double
    let health: Double
    let food: Double
    let transport_walking: Double;
    let transport_car: Double;
    let transport_train: Double;
    let transport_bus: Double;
    let transport_plane: Double;
    let household_heating: Double;
    let household_electricity: Double;
    let household_furnishings: Double;
    let household_lighting: Double;
    let clothing_fastfashion: Double;
    let clothing_sustainable: Double;
    let health_meds: Double;
    let health_scans: Double;
    let food_meat: Double;
    let food_fish: Double;
    let food_dairy: Double;
    let food_oils: Double;
    let numReportsComposingReport: Int;

}
