//
//  QuoteManager.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 01.11.2022.
//

import Foundation


class QuoteManager: ObservableObject {
  
  static var currentQuoteIndex = 0
  
  static func load(_ fileName: String) -> [Quote] {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: fileName, withExtension: "json") else {
      fatalError("Couldn't find file \(fileName)")
    }
    
    do {
      data = try Data(contentsOf: file)
    } catch {
      fatalError("Couldn't load \(fileName) \n\(error)")
    }
    
    do {
      let decoder = JSONDecoder()
      
      return try decoder.decode([Quote].self, from: data)
    } catch {
      fatalError("Couldn't parse \(fileName) as \([Quote].self) \n\(error)")
    }
  }
  
  
  func pickRandom(quotes: [Quote]) -> Quote {
    let randomQuote = quotes.randomElement()!
    
    return randomQuote
  }
  
  static func pickRandomInt() -> Int {
    return Int.random(in: 0 ..< QuoteManager.load("quotes").count)
  }
}
