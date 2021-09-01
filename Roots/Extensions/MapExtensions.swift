//
//  MapExtensions.swift
//  MapExtensions
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
import NotificationCenter

//Extend map view model with ability to notify when a region is entered
extension MapViewModel: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        didArriveAtDestination = true
        completionHandler()
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
      
        didArriveAtDestination = true
        completionHandler(.sound)
    }
}
