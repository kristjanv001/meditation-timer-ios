//
//  Meditation_TimerApp.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 03.10.2022.
//

import SwiftUI

@main
struct Meditation_TimerApp: App {
  @StateObject var appData = ApplicationData()
  
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(appData)
    }
  }
}
