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
            let csvHandler = CSVHandler(fbLogic: fbLogic)
            
            let encryptedCSV = csvHandler.readEncryptedCSV();
            let keys = PIGKeys()
            let encryptionKEY = keys.encryptionKEY
            let decryptedCSV = csvHandler.decryptCSV(encryptedText: encryptedCSV, password: encryptionKEY)
         
       
            
           
          
            
//            let success1 = writeEncryptedDoc(string: encryptedCSV)
            
           // write the encrypted file to document directory
            let docDirectory = csvHandler.getDocumentsDirectory().appendingPathComponent("sythesisedData.txt")
            let fakeDataAdded = csvHandler.appendFakeInfoForToday(existingData: decryptedCSV)

            let fakeDataEncrypted = csvHandler.encryptString(text: fakeDataAdded, key: encryptionKEY)


            let success1 = csvHandler.writeEncryptedDoc(string: fakeDataEncrypted)
           
            var statsController = StatsDataController(fbLogic: fbLogic)
                
            let viewModel = AppViewModel(statsController: statsController, fbLogic: fbLogic, directory: docDirectory)
                
         
            
//            let success = csvHandler.writeToDocDirectory(string: encryptedCSV, location: docDirectory)

            let originalPeople = statsController.convertCSVIntoArray(csvHandler: csvHandler, directory: docDirectory)
            ContentView(directory: docDirectory, fbLogic: fbLogic, originalPeople: originalPeople)
                .environmentObject(viewModel)
                .environmentObject(statsController)
                .environmentObject(fbLogic)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true;
    }
    
 
}
