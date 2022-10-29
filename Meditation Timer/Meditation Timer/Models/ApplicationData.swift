//
//  ApplicationData.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 29.10.2022.
//

import Foundation
import SwiftUI
import UserNotifications


class ApplicationData: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
  
  override init() {
    super.init()
    let center = UNUserNotificationCenter.current()
    center.delegate = self
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
    return [.banner, .sound]
  }
  
}
