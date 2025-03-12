//
//  RaceService.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 9/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Foundation

protocol RaceServiceProtocol: Sendable {
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

struct RaceAPIObject: APIRequest, Sendable {
  let path: String = "/rest/v1/racing/"
  let method: String = "GET"
  let queryParams: [String: String]
  
  func buildURL() -> URL? {
    var components = URLComponents(string: APIConfig.baseURL + path)
    components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
    return components?.url
  }
}
