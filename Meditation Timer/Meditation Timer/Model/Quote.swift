//
//  Quote.swift
//  Meditation Timer
//
//  Created by Kristjan Vingel on 31.10.2022.
//

import Foundation


struct Quote: Codable {
  var id: Int { body.hashValue }
  let body: String
  let author: String
  let source: String
}
