//
//  HomeView.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 07.10.2022.
//

import SwiftUI
import AVFoundation


extension Image {
  func buttonLabelImageModifier() -> some View {
    return self
      .imageScale(.large)
  }
}


extension View {
  func buttonModifier(background: Color, foreground: Color) -> some View {
    return self
      .tint(background)
      .buttonStyle(.borderedProminent)
      .buttonBorderShape(.capsule)
      .controlSize(.large)
      .foregroundColor(foreground)
  }
}


struct HomeView: View {
  @AppStorage("onboarding") var isOnboardingViewActive = false
  @AppStorage("currentQuote") static var currentQuoteIndex: Int = 0
  
  
  
  @EnvironmentObject private var quoteManager: QuoteManager
  @EnvironmentObject private var timerManager: TimerManager
  @EnvironmentObject private var userNotificationManager: UserNotificationManager
  @State var isAppActive = true
  @State private var isAnimating: Bool = false
  
  
  var backgroundColor = "MosaicGreen"
  var ringsColor = "ScovilleHigh"
  var timerTextColor = "ElderFlower"
  var buttonBackgroundColor = "BlueBlue"
  var buttonForeGroundColor = "ElderFlower"
  var resetButtonBackgroundColor = "ScovilleHigh"
  
  
  
  var body: some View {
    
    // MARK: - MAIN ZSTACK
    ZStack {
      

      Color(backgroundColor)
        .ignoresSafeArea(.all, edges: .all)
        
      
      // MARK: - MAIN VSTACK
      VStack {
        
        // MARK: - HEADER
        VStack {
          
          HStack {
            // TODO: Enable
            Text("Meditate")
              .font(.title)
              .fontWeight(.bold)
              .foregroundColor(.black)
            
            //            TODO: Remove
//            Button(
//              action: { isOnboardingViewActive = true },
//              label: { Text("Onb") }
//            )
//            .foregroundColor(Color("Red"))
//            .font(.footnote)
            
          } //: HSTACK END
          .padding([.bottom], 5)
          
          HStack {
            
            TimerButton(
              action: timerManager.decrementMeditationTime,
              sfSymbol: "minus"
            ).disabled(timerManager.isStarted || timerManager.totalSeconds < 10)
            

            Text(timerManager.timeString)
              .font(.system(size: 75))
              .fontWeight(.heavy)
              .frame(minWidth: 230)
              .padding([.horizontal])
              .cornerRadius(30)
              .foregroundColor(Color(timerTextColor))
            
            TimerButton(
              action: timerManager.incrementMediationTime,
              sfSymbol: "plus"
            ).disabled(timerManager.isStarted)
            
            
          }
          
        } //: HEADER VSTACK END
        
        
//        Spacer()
        
        
        // MARK: ILLUSTRATION
        ZStack {
          CircleGroupView(
            shapeColor: Color(ringsColor),
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
        }
        
        Spacer()
  
        
        // MARK: - TIMER BUTTONS
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

          Spacer()
          
          CircleButton(
            action: timerManager.stop,
            sfSymbol: "checkmark"
          ).disabled(!timerManager.isStarted)
          
        } //: TIMER BUTTONS HSTACK END
        .padding([.vertical])
        
        
        
      } //: MAIN VSTACK END
      .overlay(VStack {
        let quoteToShow: Quote = QuoteManager.load("quotes")[HomeView.currentQuoteIndex]
        
        Text("\(quoteToShow.body) — \(999)")
          .font(.body)
          .fontWeight(.light)
          .multilineTextAlignment(.center)
          .padding()
      }
               //      .frame(height: 600.0)
        .background(.ultraThinMaterial)
               //      .background(Color("LimedWhite"))
//                     .opacity(0.9)
        .cornerRadius(20)
        .padding([.bottom], 90), alignment: .bottom)
      
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
          await MainActor.run {
            //            isButtonDisabled = !authorized
          }
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
