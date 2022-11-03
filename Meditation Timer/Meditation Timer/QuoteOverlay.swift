//
//  QuoteOverlay.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 03.11.2022.
//

import SwiftUI

struct QuoteOverlay: View {
  var index: Int
  var flag: Bool = false
  
  var body: some View {
    
    VStack {
      let quoteToShow: Quote = QuoteManager.load("quotes")[index]
      
      Text("\(quoteToShow.body) — \(999)")
        .font(.body)
        .fontWeight(.light)
        .multilineTextAlignment(.center)
        .padding()
    }
    .background(.ultraThinMaterial)
    .cornerRadius(20)
    .padding([.bottom], 90)
  }
}

