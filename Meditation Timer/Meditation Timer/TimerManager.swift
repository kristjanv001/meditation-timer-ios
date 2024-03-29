//
//  TimerManager.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 01.11.2022.
//

import Foundation
import SwiftUI


class TimerManager: ObservableObject {
  static var initialTotalSeconds: Int = 10
  
  @EnvironmentObject private var userNotificationManager: UserNotificationManager
  @EnvironmentObject private var quoteManager: QuoteManager
  
  @Published var timerPublisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  @Published var totalSeconds: Int = initialTotalSeconds
  @Published var timeString: String = TimerManager.setInitialTimeString(seconds: initialTotalSeconds)
  @Published var isStarted: Bool = false
  @Published var endTime: Date = Date()
  
  @Published var meditatedSeconds: Int = 0
  
  
  static func setInitialTimeString(seconds: Int) -> String {
    var secondsLeft = seconds
    
    secondsLeft = secondsLeft % (24 * 3600)
    let hours = secondsLeft / 3600
    
    secondsLeft %= 3600
    let minutes = secondsLeft / 60
    
    secondsLeft %= 60
    let seconds = secondsLeft
    
    return "\(hours == 0 ? "" : "\(hours):")\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
  }
  
  func start() {
    withAnimation(.easeInOut(duration: 0.25)) {
      self.isStarted = true
    }
    
    self.endTime = Calendar.current.date(
      byAdding: .second,
      value: self.totalSeconds,
      to: Date()
    )!
    
    UserNotificationManager.addNotification(in: self.totalSeconds)
  }
  
  func reset() {
    self.isStarted = false
    self.meditatedSeconds = 0
    self.totalSeconds = TimerManager.initialTotalSeconds
    self.timeString = TimerManager.setInitialTimeString(seconds: TimerManager.initialTotalSeconds)
    
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }
  
  func update() {
    let now = Date()
    let diff = self.endTime.timeIntervalSince1970 - now.timeIntervalSince1970
    
    if diff <= 0 {
      self.reset()
      
      HomeView.currentQuoteIndex = QuoteManager.pickRandomInt()
      HomeView.hasSeenQuote = false
      
      return
    }
    
    let date = Date(timeIntervalSince1970: diff)
    let calendar = Calendar.current
    
    let seconds = calendar.component(.second, from: date)
    let minutes = calendar.component(.minute, from: date)
    
    self.totalSeconds = seconds
    
    self.timeString = String(format: "%02d:%02d", minutes, seconds)
    
    self.meditatedSeconds = TimerManager.initialTotalSeconds - self.totalSeconds
 
  }
  
  func stop() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    
    UserNotificationManager.addNotification(in: 1)
    
    HomeView.currentQuoteIndex = QuoteManager.pickRandomInt()
    HomeView.hasSeenQuote = false

    self.isStarted = false
    self.meditatedSeconds = 0
    self.totalSeconds = TimerManager.initialTotalSeconds
    
    withAnimation(.easeInOut(duration: 0.3)) {
      self.timeString = TimerManager.setInitialTimeString(seconds: TimerManager.initialTotalSeconds)
    }
    
  }
  
  func decrementMeditationTime() {
    if self.totalSeconds >= 10 {
      self.totalSeconds -= 5
      TimerManager.initialTotalSeconds -= 5
      self.timeString = TimerManager.setInitialTimeString(seconds: self.totalSeconds)
    }
  }


  func incrementMediationTime() {
    self.totalSeconds += 5
    TimerManager.initialTotalSeconds += 5
    self.timeString = TimerManager.setInitialTimeString(seconds: self.totalSeconds)
  }
  
  
}
