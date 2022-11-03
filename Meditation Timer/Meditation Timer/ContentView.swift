//
//  ContentView.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 03.10.2022.
//

import SwiftUI

struct ContentView: View {
  @AppStorage("onboarding") var isOnboardingViewActive = true
  
  var body: some View {
    ZStack {
      
      if isOnboardingViewActive {
        OnboardingView()
      } else {
        HomeView()
      }
      
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  
  static var previews: some View {
    ContentView()
      .environmentObject(TimerManager())
      .environmentObject(QuoteManager())
  }
}
