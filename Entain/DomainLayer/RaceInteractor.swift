//
//  RaceInteractor.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Foundation

protocol RaceInteractorProtocol: Sendable {
  /// Retrieves next races for a specified count
  /// - Parameter count: Number of races to fetch
  /// - Returns: RaceResponse containing race information
  /// - Throws: Errors during race data retrieval
  func getNextRaces(count: Int) async throws -> RaceResponse
}

final class RaceInteractor: RaceInteractorProtocol {
  private let raceService: RaceServiceProtocol
  
  init(raceService: RaceServiceProtocol) {
    self.raceService = raceService
  }
  
  func getNextRaces(count: Int) async throws -> RaceResponse {
    return try await raceService.fetchNextRaces(count: count)
  }
}

