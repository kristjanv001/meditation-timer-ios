//
//  StartButton.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 03.11.2022.
//

import SwiftUI

struct StartButton: View {
  var action: () -> Void
  
  var body: some View {
    Button(
      action: { action() },
      label: {
        HStack {
          Image(systemName: "play.fill")
            .imageScale(.large)
            .foregroundColor(Color("ElderFlower"))
          Text("Start")
            .font(.system(.title3, design: .rounded))
            .foregroundColor(Color("ElderFlower"))
        }
      }
    )
    .tint(Color("BlueBlue"))
    .buttonStyle(.borderedProminent)
    .controlSize(.large)
    .clipShape(Capsule())
  }
}




//  .tint(background)
//  .buttonStyle(.borderedProminent)
//  .buttonBorderShape(.capsule) //: TODO: ??
//  .controlSize(.large)
//  .clipShape(Circle())
