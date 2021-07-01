//
//  PIGApp.swift
//  PIG
//
//  Created by ariane hine on 13/05/2021.
//

import SwiftUI
import Firebase
import RNCryptor
import Keys

//github token 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


@main
struct PIGApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var fbLogic = FirebaseLogic()
    @State var originalPeople =  [UserData]();
    

    var body: some Scene {
        WindowGroup {
            
            let encryptedCSV = readEncryptedCSV();
            let keys = PIGXcodeprojKeys()
            let encryptionKEY = keys.encryptionKEY
            
           
          
            
//            let success1 = writeEncryptedDoc(string: encryptedCSV)
            
           // write the encrypted file to document directory
            let docDirectory = getDocumentsDirectory().appendingPathComponent("sythesisedData.txt")
            var statsController = StatsDataController(fbLogic: fbLogic)
            let viewModel = AppViewModel(statsController: statsController, fbLogic: fbLogic, directory: docDirectory)
         
            
            let success = writeToDocDirectory(string: encryptedCSV, location: docDirectory)
            
            let originalPeople = statsController.convertCSVIntoArray(directory: docDirectory)
            ContentView(directory: docDirectory, fbLogic: fbLogic, originalPeople: originalPeople)
                .environmentObject(viewModel)
                .environmentObject(statsController)
                .environmentObject(fbLogic)
        }
    }
}

//func writeEncryptedDoc(string:String)-> Bool{
//guard let location = Bundle.main.path(forResource: "synthesisedData", ofType: "csv") else {
//    print("doesn't exist")
//
// return false
//
//     }
//    do {
//
//                try string.write(to: URL(fileURLWithPath: location), atomically: true, encoding: .utf8)
//
//        print("written to \(URL(fileURLWithPath: location))")
//        return true
//
//            } catch {
//                print("didn't write")
//                print(error.localizedDescription)
//                return false
//            }
//}
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
func encryptCSV(encryptionKEY: String) -> String{

//convert that file into one long string
    guard let filepath = Bundle.main.path(forResource: "synthesisedData", ofType: "csv") else {

             return "fail"
         }
    var data = ""
    do {
        data = try String(contentsOfFile: filepath)
    } catch {
        print(error)
        return "fail"
    }
    
    let dataUTF : Data = data.data(using: .utf8)!
    
    //encrypt it
    let encryptedData = RNCryptor.encrypt(data: dataUTF, withPassword: encryptionKEY)
    
    //getting base 64 encoded string of encrypted data
    let encryptString : String = encryptedData.base64EncodedString()
    return encryptString

//        //now split that string into an array of "rows" of data.  Each row is a string.
//    var rows = data.components(separatedBy: "\n")
//
//    //if you have a header row, remove it here
//    rows.removeFirst()
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

class AppDelegate: NSObject, UIApplicationDelegate{
    
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true;
    }
    
 
}
