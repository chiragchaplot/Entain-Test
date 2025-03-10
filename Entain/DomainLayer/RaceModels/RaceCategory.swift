//
//  RaceCategory.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

// MARK: - RaceCategory

enum RaceCategory: String, CaseIterable, Identifiable {
  
  case horse = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
  case greyhound = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
  case harness = "161d9be2-e909-4326-8c2c-35ed71fb460b"
  
  var id: String { self.rawValue }
  var imageName: String {
    switch self {
    case .horse:
      return "horse-racing"
    case .greyhound:
      return "greyhound-racing"
    case .harness:
      return "harness-racing"
    }
  }
}



