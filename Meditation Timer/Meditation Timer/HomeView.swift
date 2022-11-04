//
//  HomeView.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 07.10.2022.
//

import SwiftUI
import AVFoundation


struct HomeView: View {
  @AppStorage("onboarding") var isOnboardingViewActive = false
  @AppStorage("currentQuote") static var currentQuoteIndex: Int = 0
  @AppStorage("hasSeenQuote") static var hasSeenQuote: Bool = false
  
  @State var isAppActive = true
  @State private var isAnimating: Bool = false
  @State var isQuoteOverlayVisible:  Bool = false {
    didSet {
      HomeView.hasSeenQuote = true
    }
  }
  
  @EnvironmentObject private var quoteManager: QuoteManager
  @EnvironmentObject private var timerManager: TimerManager
  @EnvironmentObject private var userNotificationManager: UserNotificationManager
  
  
  
  //  TODO: If the timer finishes aka there's a new quote, then hasSeen = true
  //  Also store to AppStorage
  
  var body: some View {
    
    // MARK: - MAIN ZSTACK
    ZStack {
      
      Color("MosaicGreen")
        .ignoresSafeArea(.all, edges: .all)
      
      // MARK: - MAIN VSTACK
      VStack {
        
        Button(
          action: { self.isOnboardingViewActive = true },
          label: {
            
            Text("Onboarding")
              .font(.system(.footnote, design: .rounded))
              .foregroundColor(Color("ElderFlower"))
            
          }
        )
        
        Text("Meditate")
          .font(.title)
          .fontWeight(.bold)
        
        Spacer()
        
        // MARK: - TIMER + BUTTONS
        VStack {
          
          HStack {
            
            TimerButton(
              action: timerManager.decrementMeditationTime,
              sfSymbol: "minus"
            ).disabled(timerManager.isStarted || timerManager.totalSeconds < 10)
            
            TimerText(time: timerManager.timeString)
            
            TimerButton(
              action: timerManager.incrementMediationTime,
              sfSymbol: "plus"
            ).disabled(timerManager.isStarted)
            
          }
          .frame(alignment: .top)
          
        } //: VSTACK
        
        Spacer()
        
        
        // MARK: - ILLUSTRATION + CIRCLES
        ZStack {
          CircleGroupView(
            shapeColor: Color("ScovilleHigh"),
            shapeOpacity: 0.5,
            isAnimating: $isAnimating
          )
          
          
          Image("character-2")
            .resizable()
            .scaledToFit()
            .offset(y: isAnimating ? 8 : -8)
            .animation(
              .easeInOut(duration: 2)
              .repeatForever()
              , value: isAnimating
            )
        } //: ZSTACK
        .frame(alignment: .center)
        
        Spacer()
        
        
        // MARK: - TIMER CONTROL BUTTONS
        HStack() {
          
          StartButton(
            action: timerManager.start
          )
          .disabled(timerManager.isStarted)
          
          CircleButton(
            action: timerManager.reset,
            sfSymbol: "arrow.triangle.2.circlepath",
            background: Color("ScovilleHigh")
          ).disabled(!timerManager.isStarted)
          
          CircleButton(
            action: timerManager.stop,
            sfSymbol: "checkmark"
          ).disabled(!timerManager.isStarted || timerManager.meditatedSeconds < 5)
          
          
          CircleButton(
            action: {
              withAnimation(.easeInOut(duration: 0.2)) {
                self.isQuoteOverlayVisible.toggle()
                HomeView.hasSeenQuote = true
              }
            },
            sfSymbol: "gift.fill",
            foreGround: HomeView.hasSeenQuote ? Color("ElderFlower") : Color("GoldenYellow")
          ).disabled(false)
          
          
          
        } //: HSTACK
        .padding([.vertical])
        .frame(alignment: .bottom)
        
        
        
      } //: MAIN VSTACK
      .overlay(
        self.isQuoteOverlayVisible ? QuoteOverlay(index: HomeView.currentQuoteIndex) : nil , alignment: .bottom
      )
      .onReceive(timerManager.timerPublisher, perform: {(_) in
        if timerManager.isStarted && isAppActive {
          timerManager.update()
        }
      })
      .onAppear(perform: ({
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: ({
          isAnimating = true
        }))
      }))
      .task(priority: .background) {
        
        do {
          let center = UNUserNotificationCenter.current()
          _ = try await center.requestAuthorization(options: [.alert, .sound])
          await MainActor.run {}
        } catch {
          print("Error: \(error)")
        }
      }
      .padding([.horizontal])
    } //: MAIN ZSTACK
    
    .preferredColorScheme(.light)
  }
}





// Previews
struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
      .environmentObject(TimerManager())
      .environmentObject(QuoteManager())
  }
}
