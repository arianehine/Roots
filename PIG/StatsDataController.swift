//
//  StatsDataController.swift
//  PIG
//
//  Created by ariane hine on 21/05/2021.
//

import SwiftUI

class StatsDataController: ObservableObject {
  
func convertCSVIntoArray() -> [UserData]{
    var people = [UserData]()
    

       //locate the file you want to use
       guard let filepath = Bundle.main.path(forResource: "synthesisedData", ofType: "csv") else {
           print("not found")
           return [UserData]()
       }

       //convert that file into one long string
       var data = ""
       do {
           data = try String(contentsOfFile: filepath)
       } catch {
           print(error)
           print("no")
           return [UserData]()
       }

       //now split that string into an array of "rows" of data.  Each row is a string.
       var rows = data.components(separatedBy: "\n")

       //if you have a header row, remove it here
       rows.removeFirst()

       //now loop around each row, and split it into each of its columns
       for row in rows {
           let columns = row.components(separatedBy: ",")

           //check that we have enough columns
           if columns.count == 8 {
            let ID = String(columns[0])
            let date = stringToDate(string: columns[1])
            let average = Double(columns[2]) ?? 0
            let transport = Double(columns[3]) ?? 0
            let household = Double(columns[4]) ?? 0
            let clothing = Double(columns[5]) ?? 0
            let health = Double(columns[6]) ?? 0
            let food = Double(columns[7]) ?? 0
            
            let person = UserData(ID: ID, date: date, average: average, transport: transport, household: household, clothing: clothing, health: health, food: food)
               people.append(person)
           }
       }
    return people;
}
}
struct UserData {
    var ID: String
    var date: Date
    var average: Double
    var transport: Double
    var household: Double
    var clothing: Double
    var health: Double
    var food: Double
}

