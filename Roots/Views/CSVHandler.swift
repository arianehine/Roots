//
//  CSVHandler.swift
//  CSVHandler
//
//  Created by Ariane Hine on 23/07/2021.
//

import Foundation
import RNCryptor
import Keys
import SwiftUI

//Deals with the decrypted CSV
//Encryption/decryption inspired by source: https://www.youtube.com/watch?v=89DEVVikzlg


class CSVHandler: ObservableObject{
    @State var fbLogic: FirebaseLogic
    //The fake data for `today'
    @Published var fakeData: UserData = UserData(ID: "0", date: Date(), average: 0, transport: 0, household: 0, clothing: 0, health: 0, food: 0, transport_walking: 0, transport_car: 0, transport_train: 0, transport_bus: 0, transport_plane: 0, household_heating: 0, household_electricity: 0, household_furnishings: 0, household_lighting: 0, clothing_fastfashion: 0, clothing_sustainable: 0, health_meds: 0, health_scans: 0, food_meat: 0, food_fish: 0, food_dairy: 0, food_oils: 0.0)
    
    //Add the fake data for today
    func appendFakeInfoForToday(existingData: String) ->String{
        var existingDataCopy = existingData
        let dataToAdd = UserData(ID: "average", date: Date(), average: 2226.49, transport: 639.88, household: 551.62, clothing: 328.91, health: 308.91, food: 397.17, transport_walking: 159.97, transport_car: 63.99, transport_train: 121.58, transport_bus: 121.58, transport_plane: 70.39, household_heating: 126.87, household_electricity: 165.49, household_furnishings: 132.39, household_lighting: 126.87, clothing_fastfashion: 179.17, clothing_sustainable: 129.74, health_meds: 210.06, health_scans: 98.85, food_meat: 123.12, food_fish: 91.35, food_dairy: 99.29, food_oils: 83.41)
        
        let stringToAppend = commaSeparate(object: dataToAdd)
        existingDataCopy.append(contentsOf: stringToAppend)
        self.fakeData = dataToAdd
        return existingDataCopy
        
    }
    
    init(fbLogic: FirebaseLogic){
        self.fbLogic = fbLogic
    }
    public func dateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    //Seperate the CSV by commas to get the data in each column
    func commaSeparate(object: UserData) -> String{
        
        var result = ""
        result.append(contentsOf: String(object.ID
                                         + ","))
        result.append(contentsOf: dateToString(date: object.date)
                      + ",")
        result.append(contentsOf: String(object.average) + ",")
        result.append(contentsOf: String(object.transport) + ",")
        result.append(contentsOf: String(object.household) + ",")
        result.append(contentsOf: String(object.clothing) + ",")
        result.append(contentsOf: String(object.health) + ",")
        result.append(contentsOf: String(object.food ) + ",")
        result.append(contentsOf: String(object.transport_walking ) + ",")
        result.append(contentsOf: String(object.transport_car)  + ",")
        result.append(contentsOf: String(object.transport_train ) + ",")
        result.append(contentsOf: String(object.transport_bus) + ",")
        result.append(contentsOf: String(object.transport_plane ) + ",")
        result.append(contentsOf: String(object.household_heating ) + ",")
        result.append(contentsOf: String(object.household_electricity) + ",")
        result.append(contentsOf: String(object.household_furnishings) + ",")
        result.append(contentsOf: String(object.household_lighting ) + ",")
        result.append(contentsOf: String(object.clothing_fastfashion) + ",")
        result.append(contentsOf: String(object.clothing_sustainable) + ",")
        result.append(contentsOf: String(object.health_meds ) + ",")
        result.append(contentsOf: String(object.health_scans ) + ",")
        result.append(contentsOf: String(object.food_meat ) + ",")
        result.append(contentsOf: String(object.food_fish ) + ",")
        result.append(contentsOf: String(object.food_dairy ) + ",")
        result.append(contentsOf: String(object.food_oils) + "\n")
        
        return result
        
    }
    
    //Set data in the CSV when the user reduces their footprint in a certain area
    func getReductionData(amount: Int, days: Int, pledgeArea: String, footprint: String) ->UserData{
        if(pledgeArea == "Transport"){
            let dataToAdd = UserData(ID: footprint, date: Date(), average: Double(-amount), transport: Double(-amount), household: 0, clothing: 0, health: 0 , food: 0, transport_walking: 0, transport_car: 0, transport_train: 0, transport_bus: 0, transport_plane: 0, household_heating: 0, household_electricity: 0, household_furnishings: 0, household_lighting: 0, clothing_fastfashion: 0, clothing_sustainable: 0, health_meds:0, health_scans: 0, food_meat: 0, food_fish: 0, food_dairy: 0, food_oils: 0)
            return dataToAdd
        }else if(pledgeArea == "Household"){
            let dataToAdd = UserData(ID: footprint, date: Date(), average: Double(-amount), transport: 0, household: Double(-amount), clothing: 0, health: 0, food: 0, transport_walking: 0, transport_car: 0, transport_train: 0, transport_bus: 0, transport_plane: 0, household_heating: 0, household_electricity: 0, household_furnishings: 0, household_lighting: 0, clothing_fastfashion: 0, clothing_sustainable: 0, health_meds:0, health_scans: 0, food_meat: 0, food_fish: 0, food_dairy: 0, food_oils: 0)
            return dataToAdd
            
        }else if(pledgeArea == "Fashion"){
            let dataToAdd = UserData(ID: footprint, date: Date(), average: Double(-amount), transport: 0, household: 0, clothing: Double(-amount), health: 0, food: 0, transport_walking: 0, transport_car: 0, transport_train: 0, transport_bus: 0, transport_plane: 0, household_heating: 0, household_electricity: 0, household_furnishings: 0, household_lighting: 0, clothing_fastfashion: 0, clothing_sustainable: 0, health_meds:0, health_scans: 0, food_meat: 0, food_fish: 0, food_dairy: 0, food_oils: 0)
            return dataToAdd
        }else if(pledgeArea == "Health"){
            let dataToAdd = UserData(ID: footprint, date: Date(), average: Double(-amount), transport: 0, household: 0, clothing:0, health: Double(-amount), food: 0, transport_walking: 0, transport_car: 0, transport_train: 0, transport_bus: 0, transport_plane: 0, household_heating: 0, household_electricity: 0, household_furnishings: 0, household_lighting: 0, clothing_fastfashion: 0, clothing_sustainable: 0, health_meds:0, health_scans: 0, food_meat: 0, food_fish: 0, food_dairy: 0, food_oils: 0)
            return dataToAdd
        }else{
            let dataToAdd = UserData(ID: footprint, date: Date(), average: Double(-amount), transport: 0, household: 0, clothing:0, health: 0, food: Double(-amount), transport_walking: 0, transport_car: 0, transport_train: 0, transport_bus: 0, transport_plane: 0, household_heating: 0, household_electricity: 0, household_furnishings: 0, household_lighting: 0, clothing_fastfashion: 0, clothing_sustainable: 0, health_meds:0, health_scans: 0, food_meat: 0, food_fish: 0, food_dairy: 0, food_oils: 0)
            return dataToAdd
        }
        
    }
    
    //Writes a string to the documents directory in a file location.
    func writeToDocDirectory(string:String, location: URL) ->Bool{
        do {
            try string.write(to: location, atomically: true, encoding: .utf8)
            
            return true
            
        } catch {
           
            return false
        }
    }
    
    //Retrieve location of doc directory
    public func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //Encrypt CSV file
    func encryptCSV(encryptionKEY: String) -> String{
        
        //Convert  file into one long string
        guard let filepath = Bundle.main.path(forResource: "synthesisedData", ofType: "csv") else {
            print("fail")
            
            return "fail"
        }
        
        var data = ""
        do {
            data = try String(contentsOfFile: filepath)
            
        } catch {
            print("fail")
    
            
        }
        
        let dataUTF : Data = data.data(using: .utf8)!
        //Encrypt it
        let encryptedData = RNCryptor.encrypt(data: dataUTF, withPassword: encryptionKEY)
        
        //Getting base 64 encoded string of encrypted data
        let encryptString : String = encryptedData.base64EncodedString()
        return encryptString
    }
    
    //Add user data to the CSV
    func appendToCSV(toAppend: UserData, statsController: StatsDataController){
        let encryptedCSV = self.readEncryptedCSV();
        let keys = PIGKeys()
        let encryptionKEY = keys.encryptionKEY
        let decryptedCSV = self.decryptCSV(encryptedText: encryptedCSV, password: encryptionKEY)
        
        // Write the encrypted file to document directory
        let docDirectory = self.getDocumentsDirectory().appendingPathComponent("sythesisedData.txt")
        let dataAdded = self.appendFakeInfoForToday(existingData: decryptedCSV)
        let dataEncrypted = self.encryptString(text: dataAdded, key: encryptionKEY)
        let success1 = self.writeEncryptedDoc(string: dataEncrypted)
        let success = self.writeToDocDirectory(string: encryptedCSV, location: docDirectory)
        
    }
    
    //Encrypts a string
    func encryptString(text: String, key: String) -> String{
        
        let dataUTF : Data = text.data(using: .utf8)!
        //Encrypt it
        let encryptedData = RNCryptor.encrypt(data: dataUTF, withPassword: key)
        //Getting base 64 encoded string of encrypted data
        let encryptString : String = encryptedData.base64EncodedString()
        return encryptString
        
    }
    
    //Write an encrypted string to the encrypted document
    func writeEncryptedDoc(string:String)-> Bool{
      
        guard let location = Bundle.main.path(forResource: "synthesisedDataEncrypted", ofType: "txt") else {
            print("doesn't exist")
            
            return false
            
        }
        do {
            try string.write(to: URL(fileURLWithPath: location), atomically: true, encoding: .utf8)
            print("encrypt length \(string.count)")
            print("writing to \(URL(fileURLWithPath: location))")
            return true
            
        } catch {
            print("didn't write")
        
            return false
        }
    }
    
    //Read the encrypted CSV
    func readEncryptedCSV() -> String{
      
        
        guard let filepath = Bundle.main.path(forResource: "synthesisedDataEncrypted", ofType: "txt") else {
            
            print("doesnt exist")
            return "fail"
        }
        var data = ""
        do {
            data = try String(contentsOfFile: filepath)
            print("read from \(filepath)")
        } catch {
            print(error)
            return "fail"
        }
 
        return data
        
    }
    
    //Decrypt CSV from encrypted string
    func decryptCSV(encryptedText: String, password: String) -> String{
        do{
            let data: Data = Data(base64Encoded: encryptedText)!
         
            let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
            let decryptedString = String(data: decryptedData, encoding: .utf8)
            print("done decrypt \(decryptedString?.count)")
            return decryptedString ?? ""
        }
        catch{
            print(error.localizedDescription)
            return "failed"
        }
    }
    
}
