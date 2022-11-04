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
    
    HStack {
      let quoteToShow: Quote = QuoteManager.load("quotes")[index]
//      Spacer()
      Text("\"\(quoteToShow.body)\" — \(quoteToShow.author)")
        .font(.body)
        .fontWeight(.light)
        .multilineTextAlignment(.center)
        .padding()
//      Spacer()
    }
    .background(.ultraThinMaterial)
    .cornerRadius(20)
    .padding([.bottom], 90)
  }
}

