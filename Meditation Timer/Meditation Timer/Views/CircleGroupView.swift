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
  @State private var isAnimating: Bool = false
  
  var body: some View {
    // MARK: - MAIN ZSTACK
    ZStack {
      
      // MARK: - CIRCLE 1
      Circle()
        .stroke(shapeColor.opacity(shapeOpacity), lineWidth: 50)
        .frame(width: 260, height: 260, alignment: .center)
      
      // MARK: - CIRCLE 2
      Circle()
        .stroke(shapeColor.opacity(shapeOpacity), lineWidth: 80)
        .frame(width: 260, height: 260, alignment: .center)
    } //: ZSTACK
    .blur(radius: isAnimating ? 0 : 10)
    .opacity(isAnimating ? 1 : 0)
    .scaleEffect(isAnimating ? 1 : 0.5)
    .animation(.easeOut(duration: 1), value: isAnimating)
    .onAppear(perform: {
      isAnimating = true
    })
  }
}


// Previews
struct CircleGroupView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color(.black)
        .ignoresSafeArea(.all, edges: .all)
      CircleGroupView(shapeColor: .white, shapeOpacity: 0.2)
    }
  }
}
