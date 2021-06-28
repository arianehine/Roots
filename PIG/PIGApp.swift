//
//  PIGApp.swift
//  PIG
//
//  Created by ariane hine on 13/05/2021.
//

import SwiftUI
import Firebase
import RNCryptor

let encryptionKEY = "$3N2@C7@pXp"
let loginUsername = "3000100"
let loginPassword = "sF52bx24v~h^s-Y+3000100"
@main
struct PIGApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var fbLogic = FirebaseLogic()
    @State var originalPeople =  [UserData]();


    var body: some Scene {
        WindowGroup {
            var statsController = StatsDataController(fbLogic: fbLogic)
            let viewModel = AppViewModel(statsController: statsController, fbLogic: fbLogic)
            let originalPeople = statsController.convertCSVIntoArray()
            ContentView(fbLogic: fbLogic, originalPeople: originalPeople)
                .environmentObject(viewModel)
                .environmentObject(statsController)
                .environmentObject(fbLogic)
        }
    }
}
//Encrypt CSV file
func encryptCSV() -> String{

//convert that file into one long string
    var data = ""
    do {
        data = try String(contentsOfFile: "sythesisedData.csv")
    } catch {

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
