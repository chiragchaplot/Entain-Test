//
//  MockRaceInteractor.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 16/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//
    
import Foundation
@testable import Entain

actor MockRaceInteractor: RaceInteractorProtocol {
  var mockResponse: RaceResponse?
  private var mockError: Error?
  private var responseGenerator: (() -> RaceResponse)?
  
  init(mockResponse: RaceResponse? = nil, mockError: Error? = nil, responseGenerator: (() -> RaceResponse)? = nil) {
    self.mockResponse = mockResponse
    self.mockError = mockError
    self.responseGenerator = responseGenerator
  }
  
  func getNextRaces(count: Int) async throws -> RaceResponse {
    if let error = mockError {
      throw error
    }
    
    if let responseGenerator = responseGenerator {
      return responseGenerator()
    }
    
    guard let response = mockResponse else {
      throw NetworkError.noData
    }
    
    return response
  }
}
