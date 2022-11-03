//
//  OnBoardingView.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 07.10.2022.
//

import SwiftUI

struct OnboardingView: View {
  @AppStorage("onboarding") var isOnboardingActive: Bool = true
  
  private let buttonHeight: CGFloat = 72
  let hapticFeedback = UINotificationFeedbackGenerator()
  
  private static var textSubtitleOne = "Achieve lazer-sharp mental focus like you've never experienced."
  private static var textSubtitleTwo = "Remain grounded and calm in unpredictable hectic situations."
  private static var textSubtitleThree = "Get timeless insights to help you stay motivated."
  
  
  @State private var textSubtitle: String = OnboardingView.textSubtitleOne
  
  @State private var textTitle: String = "Zen."
  @State private var isAnimating: Bool = false
  @State private var imageOffset: CGSize = CGSize(width: 0, height: 0)
  @State private var buttonOffset: CGFloat = 0
  @State private var buttonWidth: Double = UIScreen.main.bounds.width - 72
  @State private var indicatorOpacity: Double = 1
  
  
  
  var body: some View {
    // MARK: - MAIN ZSTACK
    ZStack {
      Color("Entrapment")
        .ignoresSafeArea(.all, edges: .all)
      
      // MARK: - MAIN VSTACK
      VStack() {
        
        // MARK: - HEADER
        VStack(spacing: 10) {
          
          // MARK: - TITLE
          Text(textTitle)
            .font(.system(size: 60))
            .fontWeight(.heavy)
            .foregroundColor(Color("Shyness"))
            .transition(.opacity)
            .id(textTitle)
          
          // MARK: - SUBTITLE
          Text(textSubtitle)
            .font(.title3)
            .fontWeight(.light)
            .foregroundColor(Color("PinkMoment"))
            .multilineTextAlignment(.center)
            .padding([.horizontal], 40)
            .frame(height: 90, alignment: .top)

        } //: HEADER
        .opacity(isAnimating ? 1 : 0)
        .offset(y: isAnimating ? 0 : -40)
        .animation(.easeOut(duration: 1), value: isAnimating)
//        .border(.white)
        
        // MARK: - CENTER
        ZStack {

          // MARK: - RINGS
          CircleGroupView(
            shapeColor: .white,
            shapeOpacity: 0.02,
            isAnimating: $isAnimating
          )
            .offset(x: imageOffset.width * -1)
            .blur(radius: abs(imageOffset.width / 5))
            .animation(.easeOut(duration: 1), value: imageOffset)
            
          
          // MARK: - IMAGE
          Image("wave-sphere")
            .resizable()
            .scaledToFit()
            .offset(x: isAnimating ? 0 : 10)
            .animation(.easeOut(duration: 1), value: isAnimating)
            .offset(x: imageOffset.width * 1.5, y: 0)
            .rotationEffect(.degrees(Double(imageOffset.width / 25)))
            .gesture(
              DragGesture()
                .onChanged({(gesture) in
                  if (-150 ... 0).contains(gesture.translation.width) {
                    imageOffset = gesture.translation
                    
                    withAnimation(.linear(duration: 0.25)) {
                      indicatorOpacity = 0
                      textSubtitle = OnboardingView.textSubtitleTwo
                    }
                  }
                  
                  if (1 ... 150).contains(gesture.translation.width) {
                    imageOffset = gesture.translation
                    
                    withAnimation(.linear(duration: 0.25)) {
                      indicatorOpacity = 0
                      textSubtitle = OnboardingView.textSubtitleThree
                    }
                  }
        
                })
                .onEnded({(_) in
                  imageOffset = CGSize(width: 0, height: 0)
                  
                  withAnimation(.linear(duration: 0.25)) {
                    indicatorOpacity = 1
                    textSubtitle = OnboardingView.textSubtitleOne
                  }
                })
            )
            .animation(.easeOut(duration: 1), value: imageOffset)
        } //: CENTER
//        .border(.red)
        .zIndex(-1)
        .overlay(
          Image(systemName: "arrow.left.and.right.circle")
            .font(.system(size: 28, weight: .ultraLight))
            .foregroundColor(.white)
//            .offset(y: 20)
            .opacity(isAnimating ? 0.5 : 0)
            .animation(.easeOut(duration: 1).delay(2), value: isAnimating)
            .opacity(indicatorOpacity)
          , alignment: .top
        )
        
        Spacer()
        
        // MARK: - FOOTER
        ZStack {
          // Background (Static)
          Capsule()
            .fill(.white.opacity(0.2))
          
          Capsule()
            .fill(.white.opacity(0.2))
            .padding(6)
          
          // Call To Action (Static)
          Text("Got it")
            .font(.system(.title3, design: .rounded))
            .fontWeight(.bold)
            .foregroundColor(Color("Shyness"))
            .offset(x: 20)
          
          // Capsule (Dynamic)
          HStack {
            Capsule()
              .fill(Color("PinkMoment"))
              .opacity(1)
              .frame(width: buttonOffset > buttonWidth / 2 ? buttonOffset + 62 : buttonOffset + buttonHeight)
            Spacer()
          }
          
          // Circle (Draggable)
          HStack {
            ZStack {
              Circle()
                .fill(Color("PinkMoment"))
              Circle()
                .fill(.black.opacity(0.15))
                .padding(6)
              Image(systemName: "chevron.right.2")
                .font(.system(size: 24, weight: .bold, design: .rounded))
            } //: ZSTACK
            .foregroundColor(Color("Shyness"))
            .frame(width: buttonHeight) // TODO: Weird
            .offset(x: buttonOffset)
            .gesture(
              DragGesture()
                .onChanged({(gesture) in
                  if gesture.translation.width > 0 &&
                      buttonOffset <= buttonWidth - buttonHeight {
                    buttonOffset = gesture.translation.width
                  }
                })
                .onEnded({(_) in
                  withAnimation(.easeOut(duration: 0.4)) {
                    if buttonOffset > buttonWidth / 1.5 {
                      hapticFeedback.notificationOccurred(.success)
                      buttonOffset = buttonWidth - buttonHeight
                      isOnboardingActive = false
                    } else {
                      hapticFeedback.notificationOccurred(.warning)
                      buttonOffset = 0
                    }
                  }
                })
            )
            Spacer()
          } //: HSTACK
        } //: FOOTER
        .frame(width: buttonWidth, height: buttonHeight, alignment: .center)
        .opacity(isAnimating ? 1 : 0)
        .offset(y: isAnimating ? 2 : 0)
        .animation(.easeOut(duration: 1), value: isAnimating)
        .padding([.bottom], 5)
//        .border(.red)
      } //: MAIN VSTACK
      .padding()
    } //: MAIN ZSTACK
    .onAppear(perform: {
      isAnimating = true
    })
    .preferredColorScheme(.dark)
  }
}



// PREVIEWS
struct OnBoardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView()
      .previewDevice("iPhone 13")
    OnboardingView()
      .previewDevice("iPod touch (7th generation)")
  }
}
