//
//  MockURLSession.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Foundation
@testable import Entain

class MockURLSession: URLSessionProtocol {
  var data: Data?
  var response: URLResponse?
  var error: Error?
  
  func data(for request: URLRequest) async throws -> (Data, URLResponse) {
    if let error = error {
      throw error
    }
    return (data ?? Data(), response ?? HTTPURLResponse())
  }
}
