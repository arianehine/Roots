//
//  PIGApp.swift
//  PIG
//
//  Created by ariane hine on 13/05/2021.
//

import SwiftUI
import Firebase

@main
struct PIGApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var fbLogic = FirebaseLogic()
    @State var originalPeople =  [UserData]();

    var body: some Scene {
        WindowGroup {
            var statsController = StatsDataController(fbLogic: fbLogic)
            let viewModel = AppViewModel(statsController: statsController)
            let originalPeople = statsController.convertCSVIntoArray()
            ContentView(originalPeople: originalPeople)
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
