//
//  CSVHandler.swift
//  CSVHandler
//
//  Created by Ariane Hine on 23/07/2021.
//

import Foundation
import RNCryptor

class CSVHandler: ObservableObject{
    func appendFakeInfoForToday(existingData: String) ->String{
        
        var existingDataCopy = existingData

        let dataToAdd = UserData(ID: "8", date: Date(), average: 2226.49, transport: 639.88, household: 551.62, clothing: 328.91, health: 308.91, food: 397.17, transport_walking: 159.97, transport_car: 63.99, transport_train: 121.58, transport_bus: 121.58, transport_plane: 70.39, household_heating: 126.87, household_electricity: 165.49, household_furnishings: 132.39, household_lighting: 126.87, clothing_fastfashion: 179.17, clothing_sustainable: 129.74, health_meds: 210.06, health_scans: 98.85, food_meat: 123.12, food_fish: 91.35, food_dairy: 99.29, food_oils: 83.41)
      
        print(dataToAdd)
        let stringToAppend = commaSeparate(object: dataToAdd)
        existingDataCopy.append(contentsOf: stringToAppend)
print(existingDataCopy)
        return existingDataCopy
        
    }
    public func dateToString(date: Date) -> String{
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        // Convert Date to String
        return dateFormatter.string(from: date)
    }

    
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
    func reduceFootprint(amount: Int, days: Int){
        
    }
    
    func writeToDocDirectory(string:String, location: URL) ->Bool{
    do {
                try string.write(to: location, atomically: true, encoding: .utf8)

        return true
               
            } catch {
                print(error.localizedDescription)
                return false
            }
    }


    public func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }

    //Encrypt CSV file
//    func encryptCSV(encryptionKEY: String) -> String{
//
//    //convert that file into one long string
//        guard let filepath = Bundle.main.path(forResource: "synthesisedData", ofType: "csv") else {
//
//                 return "fail"
//             }
//
//        var data = ""
//        do {
//            data = try String(contentsOfFile: filepath)
//
//        } catch {
//            print(error)
//            return "fail"
//        }
//
//        let dataUTF : Data = data.data(using: .utf8)!
//
//        //encrypt it
//        let encryptedData = RNCryptor.encrypt(data: dataUTF, withPassword: encryptionKEY)
//
//        //getting base 64 encoded string of encrypted data
//        let encryptString : String = encryptedData.base64EncodedString()
//        return encryptString
//    }

    //        //now split that string into an array of "rows" of data.  Each row is a string.
    //    var rows = data.components(separatedBy: "\n")
    //
    //    //if you have a header row, remove it here
    //    rows.removeFirst()
    
    
    func encryptString(text: String, key: String) -> String{


        let dataUTF : Data = text.data(using: .utf8)!
        
        //encrypt it
        let encryptedData = RNCryptor.encrypt(data: dataUTF, withPassword: key)
        
        //getting base 64 encoded string of encrypted data
        let encryptString : String = encryptedData.base64EncodedString()
        return encryptString

    //        //now split that string into an array of "rows" of data.  Each row is a string.
    //    var rows = data.components(separatedBy: "\n")
    //
    //    //if you have a header row, remove it here
    //    rows.removeFirst()
    }
    
    
    func writeEncryptedDoc(string:String)-> Bool{
        print("writing")
    guard let location = Bundle.main.path(forResource: "synthesisedDataEncrypted", ofType: "txt") else {
        print("doesn't exist")

     return false

         }
        do {

                    try string.write(to: URL(fileURLWithPath: location), atomically: true, encoding: .utf8)

            print("written to \(URL(fileURLWithPath: location))")
            return true

                } catch {
                    print("didn't write")
                    print(error.localizedDescription)
                    return false
                }
    }

    func readEncryptedCSV() -> String{

    //convert that file into one long string
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

    //        //now split that string into an array of "rows" of data.  Each row is a string.
    //    var rows = data.components(separatedBy: "\n")
    //
    //    //if you have a header row, remove it here
    //    rows.removeFirst()
    }

    //adapted from https://www.youtube.com/watch?v=89DEVVikzlg
    func decryptCSV(encryptedText: String, password: String) -> String{
        do{
            let data: Data = Data(base64Encoded: encryptedText)!
            let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
            let decryptedString = String(data: decryptedData, encoding: .utf8)
            return decryptedString ?? ""
        }
        catch{
            return "failed"
        }
    }

}
