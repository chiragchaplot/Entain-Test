//
//  Bundle+Extension.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//
    
import Foundation
@testable import Entain

extension Bundle {
  func decode<T: Decodable>(_ type: T.Type, from file: String) throws -> T {
    guard let url = self.url(forResource: file, withExtension: nil) else {
      throw NSError(domain: "BundleError", code: 404, userInfo: [NSLocalizedDescriptionKey: "File not found: \(file)"])
    }
    
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    return try decoder.decode(T.self, from: data)
  }
}
