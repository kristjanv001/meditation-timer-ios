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
  @State private var isAnimating: Bool = false
  @StateObject private var timerModel = TimerModel()
  
  var body: some View {
    // MARK: - MAIN ZSTACK
    ZStack {
      Color("LimedWhite")
        .ignoresSafeArea(.all, edges: .all)
      
      // MARK: - MAIN VSTACK
      VStack {
        
        // MARK: - HEADER
        VStack {
          
          HStack {
            // TODO: Enable
//            Text("Meditate")
//              .font(.title3)
//              .fontWeight(.light)
//              .foregroundColor(.secondary)
            
//            TODO: Remove
            Button(
              action: { isOnboardingViewActive = true },
              label: { Text("Onb") }
            )
            .foregroundColor(Color("Red"))
            .font(.footnote)
            
          } //: HSTACK END
          .padding([.bottom], 5)
          
          HStack {
            
            Button(
              action: {
                if timerModel.totalSeconds >= 10 {
                  timerModel.totalSeconds -= 5
                  timerModel.timerString = TimerModel.setInitialTimerString(seconds: timerModel.totalSeconds)
                }
                
              },
              label: {
                Image(systemName: "minus")
                  .frame(height: 20)
              }
            )
            .tint(Color("Capsella"))
            .foregroundColor(Color("LuckyPotato"))
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
            .clipShape(Circle())
            .disabled(timerModel.isStarted || timerModel.totalSeconds < 10)
            
            
            Text(timerModel.timerString)
              .fontWeight(.semibold)
              .frame(height: 35)
              .padding([.horizontal])
              .background(.thickMaterial)
              .background(Color("LimedWhite"))
              .opacity(0.3)
              .cornerRadius(30)
            
            Button(
              action: {
                timerModel.totalSeconds += 5
                timerModel.timerString = TimerModel.setInitialTimerString(seconds: timerModel.totalSeconds)
              },
              label: {
                Image(systemName: "plus")
                  .frame(height: 20)
              }
            )
            .tint(Color("Capsella"))
            .foregroundColor(Color("LuckyPotato"))
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
            .clipShape(Circle())
            .disabled(timerModel.isStarted)
          }
          
        } //: HEADER VSTACK END
        .padding([.bottom])
        
        Spacer()
        
        // MARK: ILLUSTRATION
        ZStack {
          
          CircleGroupView(
            shapeColor: .black,
            shapeOpacity: 0.05,
            isAnimating: $isAnimating
          )
          
          Image("character-2")
            .resizable()
            .scaledToFit()
            .offset(y: isAnimating ? 8 : -8)
            .animation(
              .easeInOut(duration: 2)
              .repeatForever()
              , value: isAnimating)
        } //: ILLUSTRATION END
        
        Spacer()
        
        // MARK: - TEXT BOX
        VStack {
          Text("“The past has no power over the present moment.” – Eckhart Tolle")
            .font(.body)
            .fontWeight(.light)
            .multilineTextAlignment(.center)
            .padding()
        }
        .background(.thickMaterial)
        .background(Color("LimedWhite"))
        .opacity(0.3)
        .cornerRadius(30)
        
        Spacer()
        
        // MARK: - TIMER
        HStack() {
          
          // MARK: - START BUTTON
          Button(
            action: {
              timerModel.start()
            },
            label: {
              HStack {
                Image(systemName: "play.fill")
                Text("Start")
                  .font(.system(.title3, design: .rounded))
                  .foregroundColor(Color("LuckyPotato"))
              } //: HSTACK END
            }
          )
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.capsule)
          .controlSize(.large)
          .tint(Color("Capsella"))
          .foregroundColor(Color("LuckyPotato"))
          .disabled(timerModel.isStarted)
          

          // MARK: - RESET BUTTON
          Button(
            action: {
              timerModel.reset()
              UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            },
            label: {
              Image(systemName: "arrow.triangle.2.circlepath").imageScale(.large)
                .frame(width: 20, height: 20)
            }
          )
          .tint(Color("Red"))
          .disabled(!timerModel.isStarted)
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.capsule)
          .controlSize(.large)
          .foregroundColor(Color("LuckyPotato"))
          .clipShape(Circle())
          
          Spacer()
          
          // MARK: - STOP / DONE BUTTON
          Button(
            action: { timerModel.stop() },
            label: {
              Image(systemName: "checkmark").imageScale(.large)
                .frame(width: 20, height: 20)
            }
          )
          .tint(Color("Capsella"))
          .disabled(!timerModel.isStarted)
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.capsule)
          .controlSize(.large)
          .foregroundColor(Color("LuckyPotato"))
          .clipShape(Circle())
        } //: BUTTONS HSTACK END
      } //: MAIN VSTACK
      .onReceive(timerModel.timerPublisher, perform: {(_) in
        if timerModel.isStarted && timerModel.isAppActive {
          timerModel.update()
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
      .padding()
    } //: MAIN ZSTACK
    .preferredColorScheme(.light)
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
