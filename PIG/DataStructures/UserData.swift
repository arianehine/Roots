//
//  UserData.swift
//  UserData
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
import SwiftUI
//The data structure holding the user data - in the same format as it is in Firestore
struct UserData: Hashable{
    var ID: String
    var date: Date
    var average: Double
    var transport: Double
    var household: Double
    var clothing: Double
    var health: Double
    var food: Double
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
}

