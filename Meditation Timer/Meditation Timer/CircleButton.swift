//
//  StartButton.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 03.11.2022.
//

import SwiftUI

struct CircleButton: View {
  var action: () -> Void
  var sfSymbol: String
  var background: Color = Color("BlueBlue")
  var foreGround: Color = Color("ElderFlower")

  
  var body: some View {
    Button(
      action: { action() },
      label: {
        HStack {
          Image(systemName: sfSymbol)
            .imageScale(.large)
            .foregroundColor(foreGround)
        }
      }
    )
    .tint(background)
    .buttonStyle(.borderedProminent)
    .controlSize(.large)
    .clipShape(Circle())
  }
}


