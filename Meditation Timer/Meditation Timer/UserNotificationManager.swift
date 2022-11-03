//
//  ApplicationData.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 29.10.2022.
//

import Foundation
import SwiftUI
import UserNotifications


class UserNotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
  
  override init() {
    super.init()
    let center = UNUserNotificationCenter.current()
    center.delegate = self
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
    return [.banner, .sound]
  }
  
  static func addNotification(in time: Int) {
    let content = UNMutableNotificationContent()
    content.title = "Meditation Session"
    content.subtitle = "Your meditation session has completed"
    content.body = "Random new quote here every time - which will also be present in the text view of the home view :)"
    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "success.m4a"))
    
    let trigger = UNTimeIntervalNotificationTrigger(
      timeInterval: Double(time),
      repeats: false
    )
    
    let request = UNNotificationRequest(
      identifier: UUID().uuidString,
      content: content,
      trigger: trigger
    )
    
    UNUserNotificationCenter.current().add(request)
  }
  
}
