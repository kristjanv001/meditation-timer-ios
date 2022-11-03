//
//  TimerText.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 03.11.2022.
//

import SwiftUI

struct TimerText: View {
  var time: String
  
  var body: some View {
    Text(time)
      .font(.system(size: 75))
      .fontWeight(.heavy)
      .frame(minWidth: 230)
      .padding([.horizontal])
      .cornerRadius(30)
      .foregroundColor(Color("ElderFlower"))
  }
}
