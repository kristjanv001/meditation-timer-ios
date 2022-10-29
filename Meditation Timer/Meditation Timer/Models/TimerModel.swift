//
//  TimerModel.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 24.10.2022.
//

import Foundation
import SwiftUI


final class TimerModel: ObservableObject {
  
//  static var initialTotalSeconds = 62
  static var initialTotalSeconds = 5
//  private static var initialTotalSeconds = 2891 // 48 minutes; 11 seconds
  private var totalSeconds = initialTotalSeconds
  
  
  @Published public var timerString: String = TimerModel.setInitialTimerString(seconds: initialTotalSeconds)
  
  @Published var isStarted: Bool = false
  @Published var isFinished: Bool = false
  @Published var isAppActive = true
  private var didTimerFinishInBackground = false
  
  @Published var endTime = Date()
  
  @Published public private(set) var timerPublisher = Timer.publish(
    every: 1,
    on: RunLoop.main,
    in: .common
  ).autoconnect()
  
  
  func start() {
    withAnimation(.easeInOut(duration: 0.25)) { self.isStarted = true }
    
    self.endTime = Calendar.current.date(
      byAdding: .second,
      value: TimerModel.initialTotalSeconds,
      to: Date()
    )!

    self.addNotification(in: TimerModel.initialTotalSeconds)
  }
  
  
  func reset() {
    self.isStarted = false
    self.timerString = TimerModel.setInitialTimerString(seconds: TimerModel.initialTotalSeconds)
  }
  
  
  func stop() {
    // Does the same as reset except totalseconds goes to storage
  }
  
  func update() {
    let now = Date()
    let diff = self.endTime.timeIntervalSince1970 - now.timeIntervalSince1970
    
    
    
    if diff <= 0 {
      self.isFinished = true
      
      self.reset()
      
      return
    }
    
    let date = Date(timeIntervalSince1970: diff)
    let calendar = Calendar.current
    
    let seconds = calendar.component(.second, from: date)
    let minutes = calendar.component(.minute, from: date)
    
    self.totalSeconds = seconds
    
    self.timerString = String(format: "%02d:%02d", minutes, seconds)

  }

  
  
  private static func setInitialTimerString(seconds: Int) -> String {
    var secondsLeft = seconds
    
    secondsLeft = secondsLeft % (24 * 3600)
    let hours = secondsLeft / 3600

    secondsLeft %= 3600
    let minutes = secondsLeft / 60

    secondsLeft %= 60
    let seconds = secondsLeft
    
    return "\(hours == 0 ? "" : "\(hours):")\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
  }
  
  

  func addNotification(in time: Int) {
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
