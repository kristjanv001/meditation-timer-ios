//
//  Meditation_TimerApp.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 03.10.2022.
//

import SwiftUI

@main
struct Meditation_TimerApp: App {
  @StateObject var timerManager = TimerManager()
  @StateObject var quoteManager = QuoteManager()
  @StateObject var userNotificationManager = UserNotificationManager()
  
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(timerManager)
        .environmentObject(quoteManager)
        .environmentObject(userNotificationManager)
    }
  }
}
