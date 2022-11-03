//
//  CircleGroupView.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 07.10.2022.
//

import SwiftUI

struct CircleGroupView: View {
  @State var shapeColor: Color
  @State var shapeOpacity: Double
  @Binding var isAnimating: Bool
  
  var width: CGFloat = 260
  var height: CGFloat = 260
  
  var body: some View {
    // MARK: - MAIN ZSTACK
    ZStack {
      
      // MARK: - CIRCLE 1
      Circle()
        .stroke(shapeColor.opacity(shapeOpacity), lineWidth: 50)
//        .frame(width: self.width, height: self.height, alignment: .center)
        .frame(maxWidth: self.width, maxHeight: self.height, alignment: .center)
      
      // MARK: - CIRCLE 2
      Circle()
        .stroke(shapeColor.opacity(shapeOpacity), lineWidth: 80)
//        .frame(width: self.width, height: self.height, alignment: .center)
        .frame(maxWidth: self.width, maxHeight: self.height, alignment: .center)
    } //: ZSTACK!Viishtpudus2017;
    
    .padding([.vertical])
    .blur(radius: isAnimating ? 0 : 10)
    .opacity(isAnimating ? 1 : 0)
    .scaleEffect(isAnimating ? 1 : 0.5)
    .animation(.easeOut(duration: 1), value: isAnimating)
    .onAppear(perform: {
      isAnimating = true
    })
  }
}



