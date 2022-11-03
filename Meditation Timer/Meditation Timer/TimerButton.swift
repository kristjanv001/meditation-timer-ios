//
//  TimerButton.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 03.11.2022.
//

import SwiftUI

struct TimerButton: View {
  var action: () -> Void
  var sfSymbol: String
  
  var body: some View {
    Button(
      action: { action() },
      label: {
        Image(systemName: sfSymbol)
          .frame(width: 20, height: 20)
      }
    )
    .tint(Color("BlueBlue"))
    .foregroundColor(Color("ElderFlower"))
    .buttonStyle(.borderedProminent)
    .buttonBorderShape(.roundedRectangle)
    .clipShape(Circle())
  }
}






