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

//The main class of the app where everything is launched from
//This class is purely set-up logic
@main
struct PIGApp: App {
    
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var fbLogic = FirebaseLogic()
    @State var footprint: String = ""
    @State var originalPeople =  [UserData]();
    

    var body: some Scene {
        //Set up the encryption key, and decrypt the encrypted CSV file
        WindowGroup {
            let keys = PIGKeys()
            let encryptionKEY = keys.encryptionKEY
            let csvHandler = CSVHandler(fbLogic: fbLogic)
            //Uncomment these if you have new encrypted data you need to write in an encrypted format and make sure that you put the data you want to encrypt in a file named synthesisedData.
            
//            let encrypt = csvHandler.encryptCSV(encryptionKEY: encryptionKEY)
//            let suc = csvHandler.writeEncryptedDoc(string: encrypt)
            let encryptedCSV = csvHandler.readEncryptedCSV();

            let decryptedCSV = csvHandler.decryptCSV(encryptedText: encryptedCSV, password: encryptionKEY)
            
       
            //Write the encrypted file to document directory
            let docDirectory = csvHandler.getDocumentsDirectory().appendingPathComponent("sythesisedData.txt")
            //Add data for today
//            let fakeDataAdded = csvHandler.appendFakeInfoForToday(existingData: decryptedCSV)
//            let fakeDataEncrypted = csvHandler.encryptString(text: fakeDataAdded, key: encryptionKEY)
//            
//            //Set up these for use elsewhere
//            let success1 = csvHandler.writeEncryptedDoc(string: fakeDataEncrypted)
            var statsController = StatsDataController(fbLogic: fbLogic)
            let viewModel = AppViewModel(statsController: statsController, fbLogic: fbLogic, directory: docDirectory)
                
         
            
            let success = csvHandler.writeToDocDirectory(string: encryptedCSV, location: docDirectory)
            let originalPeople = statsController.convertCSVIntoArray(csvHandler: csvHandler, directory: docDirectory)
           
            //Display the rest of the app
            ContentView(directory: docDirectory, fbLogic: fbLogic, originalPeople: originalPeople)
                .environmentObject(viewModel)
                .environmentObject(statsController)
                .environmentObject(fbLogic)
                .preferredColorScheme(.dark);
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true;
    }
    
 
}
