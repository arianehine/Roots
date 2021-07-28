//
//  MapExtensions.swift
//  MapExtensions
//
//  Created by Ariane Hine on 28/07/2021.
//

import Foundation
import NotificationCenter

extension MapViewModel: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void
    ) {
      // 2
      print("Received Notification")
      // 3
        didArriveAtDestination = true
      completionHandler()
    }

    // 4
    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      willPresent notification: UNNotification,
      withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
      // 5
      print("Received Notification in Foreground")
      // 6
        didArriveAtDestination = true
      completionHandler(.sound)
    }
}
