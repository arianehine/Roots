//
//  Pledge.swift
//  Pledge
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation

public struct Pledge : Identifiable{
    public var id: Int
    var description: String
    var category: String
    var imageName: String
    var durationInDays: Int
    var startDate: Date
    var started: Bool
    var completed: Bool
    var daysCompleted: Int
    var endDate: String
    var XP: Int
    var notifications: Bool
    var reductionPerDay: Int
    
    
}
