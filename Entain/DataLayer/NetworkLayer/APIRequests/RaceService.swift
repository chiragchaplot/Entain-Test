//
//  RaceService.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 9/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Foundation

protocol RaceServiceProtocol: Sendable {
  /// Fetches next races for a specified count
  /// - Parameter count: Number of races to fetch
  /// - Returns: RaceResponse containing race information
  /// - Throws: Network-related errors during fetch
  func fetchNextRaces(count: Int) async throws -> RaceResponse
}

final class RaceService: RaceServiceProtocol {
  private let networkManager: NetworkService
  
  init(networkManager: NetworkService = NetworkManager()) {
    self.networkManager = networkManager
  }
  
  func fetchNextRaces(count: Int) async throws -> RaceResponse {
    let apiObject = RaceAPIObject(
      queryParams: ["method": "nextraces", "count": "\(count)"]
    )
    
    guard let url = apiObject.buildURL() else {
      throw NetworkError.invalidURL
    }
    
    return try await networkManager.fetch(url: url, responseType: RaceResponse.self)
  }
}

/// Represents API request configuration for race-related network calls
struct RaceAPIObject: APIRequest, Sendable {
  let path: String = "/rest/v1/racing/"
  let method: String = "GET"
  let queryParams: [String: String]
  
  /// Constructs a complete URL for the race API request
  /// - Returns: Fully formed URL with base URL and query parameters, or nil if invalid
  func buildURL() -> URL? {
    var components = URLComponents(string: APIConfig.baseURL + path)
    components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
    return components?.url
  }
}
