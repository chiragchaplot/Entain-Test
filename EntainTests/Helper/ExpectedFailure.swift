//
//  ExpectedFailure.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 16/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//
    
struct ExpectedFailure: Error, CustomStringConvertible {
  let description: String
  
  init(_ description: String) {
    self.description = description
  }
}
