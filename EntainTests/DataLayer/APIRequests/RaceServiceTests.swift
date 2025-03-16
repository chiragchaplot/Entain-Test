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

@Suite("RaceService Tests")
class RaceServiceTests {
  
  @Test("Fetch next races should return successful response with correct data")
  func fetchNextRacesSuccessful() async throws {
    let jsonData = Bundle(for: Self.self).jsonData(fromResource: "RaceResponseJsonFixture")!
    let mockNetworkManager = MockNetworkManager()
    await mockNetworkManager.setupSuccess(with: jsonData)
    let sut = RaceService(networkManager: mockNetworkManager)
    
    let result = try await sut.fetchNextRaces(count: 10)
    
    #expect(result.status == 200)
    #expect(result.message == "Next 10 races from each category")
    #expect(result.data != nil)
    #expect(result.data?.nextToGoIDS?.count == 10)
    #expect(result.data?.raceSummaries?.count == 10)
    
    let capturedURL = await mockNetworkManager.getCapturedURL()
    #expect(capturedURL != nil)
    let urlString = capturedURL?.absoluteString ?? ""
    #expect(urlString.contains(APIConfig.baseURL + "/rest/v1/racing/"))
    #expect(urlString.contains("method=nextraces"))
    #expect(urlString.contains("count=10"))
  }
  
  @Test("Fetch next races should handle zero count")
  func fetchNextRacesZeroCount() async throws {
    let jsonData = Bundle(for: Self.self).jsonData(fromResource: "RaceResponseJsonFixture")!
    let mockNetworkManager = MockNetworkManager()
    await mockNetworkManager.setupSuccess(with: jsonData)
    let sut = RaceService(networkManager: mockNetworkManager)
    
    let result = try await sut.fetchNextRaces(count: 0)
    
    let capturedURL = await mockNetworkManager.getCapturedURL()
    #expect(capturedURL != nil)
    let urlString = capturedURL?.absoluteString ?? ""
    #expect(urlString.contains("count=0"))
  }
  
  @Test("Fetch next races should throw invalidURL error")
  func fetchNextRacesInvalidURL() async throws {
    struct FailingAPIObject: APIRequest {
      let path: String = "/invalid/path"
      let method: String = "GET"
      let queryParams: [String: String] = [:]
      
      func buildURL() -> URL? {
        return nil
      }
    }
    
    struct FailingNetworkManager: NetworkService {
      func fetch<T: Decodable>(url: URL?, responseType: T.Type) async throws -> T {
        throw NetworkError.invalidURL
      }
    }
    
    let sut = RaceService(networkManager: FailingNetworkManager())
    
    do {
      _ = try await sut.fetchNextRaces(count: 5)
      throw ExpectedFailure("Should have thrown invalidURL error")
    } catch let error as NetworkError {
      #expect(error == .invalidURL)
    }
  }
  
  @Test("Fetch next races should verify race categories")
  func fetchNextRacesCategories() async throws {
    let jsonData = Bundle(for: Self.self).jsonData(fromResource: "RaceResponseJsonFixture")!
    let mockNetworkManager = MockNetworkManager()
    await mockNetworkManager.setupSuccess(with: jsonData)
    let sut = RaceService(networkManager: mockNetworkManager)
    
    let result = try await sut.fetchNextRaces(count: 10)
    
    let raceSummaries = result.data?.raceSummaries ?? [:]
    
    let horseCategoryID = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
    let harnessCategoryID = "161d9be2-e909-4326-8c2c-35ed71fb460b"
    
    var horseRaceCount = 0
    var harnessRaceCount = 0
    
    for (_, race) in raceSummaries {
      if race.categoryID == horseCategoryID {
        horseRaceCount += 1
      } else if race.categoryID == harnessCategoryID {
        harnessRaceCount += 1
      }
    }
    
    #expect(horseRaceCount > 0, "Should have at least one horse race")
    #expect(harnessRaceCount > 0, "Should have at least one harness race")
  }
}
