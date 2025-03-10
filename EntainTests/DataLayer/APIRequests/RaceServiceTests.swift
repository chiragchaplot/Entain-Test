//
//  RaceServiceTests.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Testing
import Foundation
@testable import Entain

struct RaceServiceTests {
  @Test
  func raceServiceFetchNextRacesSuccess() async throws {
    let mockNetworkManager = MockNetworkManager()
    let raceService = RaceService(networkManager: mockNetworkManager)
    let jsonData = try loadLocalJSONFile(named: "RaceResponseJsonFixture.json")
    mockNetworkManager.mockResponseData = jsonData
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    
    let result = try await raceService.fetchNextRaces(count: 10)
    
    #expect(result.status == 200)
    #expect(result.data?.nextToGoIDS?.count == 10)
  }
  
  @Test
  func raceServiceFetchNextRacesInvalidURL() async {
    struct InvalidAPIObject: APIRequest {
      let path: String = ""
      let method: String = ""
      let queryParams: [String: String] = [:]
      
      func buildURL() -> URL? {
        return nil
      }
    }
    
    let mockNetworkManager = MockNetworkManager()
    let raceService = RaceService(networkManager: mockNetworkManager)
    
    await #expect(throws: NetworkError.noData) {
      _ = try await raceService.fetchNextRaces(count: -1)
    }
  }
  
  @Test
  func raceServiceFetchNextRacesDecodingError() async {
    let mockNetworkManager = MockNetworkManager()
    let raceService = RaceService(networkManager: mockNetworkManager)
    
    mockNetworkManager.mockResponseData = """
              { "invalid_key": "invalid_value" }
              """.data(using: .utf8)
    
    await #expect {
      _ = try await raceService.fetchNextRaces(count: 2)
    } throws: { error in
      guard let networkError = error as? NetworkError else { return false }
      if case .decodingFailed(_) = networkError {
        return true
      }
      return false
    }
  }
  
  @Test
  func raceServiceFetchNextRacesRequestFailed() async {
    let mockNetworkManager = MockNetworkManager()
    let raceService = RaceService(networkManager: mockNetworkManager)
    
    mockNetworkManager.mockError = NetworkError.requestFailed(404)
    
    await #expect(throws: NetworkError.requestFailed(404)) {
      _ = try await raceService.fetchNextRaces(count: 2)
    }
  }
  
  func loadLocalJSONFile(named fileName: String) throws -> Data {
    let thisSourceFile = URL(fileURLWithPath: #file)
    let thisDirectory = thisSourceFile.deletingLastPathComponent()
    let resourceURL = thisDirectory.appendingPathComponent(fileName)
    return try Data(contentsOf: resourceURL)
  }
}
