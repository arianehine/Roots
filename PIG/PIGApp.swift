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
    @State var statsController = StatsDataController();
    @State var originalPeople =  [UserData]();

    var body: some Scene {
        WindowGroup {
            let viewModel = AppViewModel();
            let originalPeople = statsController.convertCSVIntoArray()
            ContentView(originalPeople: originalPeople)
                .environmentObject(viewModel)
                .environmentObject(statsController)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true;
    }
}
