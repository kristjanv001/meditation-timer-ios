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

  
  var body: some View {
    Button(
      action: { action() },
      label: {
        HStack {
          Image(systemName: sfSymbol)
            .imageScale(.large)
            .foregroundColor(Color("ElderFlower"))
        }
      }
    )
    .tint(background)
    .buttonStyle(.borderedProminent)
    .buttonBorderShape(.capsule) //: TODO: ??
    .controlSize(.large)
    .clipShape(Circle())
  }
}


