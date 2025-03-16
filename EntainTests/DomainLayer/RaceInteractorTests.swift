//
//  RaceInteractorTests.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Testing
import Foundation
@testable import Entain

@Suite("RaceInteractor Tests")
struct RaceInteractorTests {
  @Test("Get next races should successfully delegate to race service")
  func getNextRacesSuccessful() async throws {
    let mockRaceResponse = RaceResponse(
      status: 200,
      data: DataClass(
        nextToGoIDS: ["race1", "race2"],
        raceSummaries: [:]
      ),
      message: "Next 10 races from each category"
    )
    
    let mockRaceService = MockRaceService(mockResponse: mockRaceResponse)
    let sut = RaceInteractor(raceService: mockRaceService)
    
    let result = try await sut.getNextRaces(count: 10)
    
    #expect(result.status == 200)
    #expect(result.message == "Next 10 races from each category")
    #expect(mockRaceService.fetchCalledWithCount == 10)
  }
  
  @Test("Get next races should propagate service errors")
  func getNextRacesError() async throws {
    let mockRaceService = MockRaceService(mockError: NetworkError.noData)
    let sut = RaceInteractor(raceService: mockRaceService)
    
    do {
      _ = try await sut.getNextRaces(count: 5)
      throw ExpectedFailure("Should have thrown an error")
    } catch let error as NetworkError {
      #expect(error == .noData)
    }
  }
  
  @Test("Get next races should handle different race counts")
  func getNextRacesDifferentCounts() async throws {
    let mockRaceService = MockRaceService(mockResponse: RaceResponse(
      status: 200,
      data: DataClass(
        nextToGoIDS: ["race1", "race2"],
        raceSummaries: [:]
      ),
      message: nil
    ))
    let sut = RaceInteractor(raceService: mockRaceService)
    
    let testCounts = [0, 1, 10, 100]
    
    for count in testCounts {
      let result = try await sut.getNextRaces(count: count)
      #expect(mockRaceService.fetchCalledWithCount == count)
      #expect(result.status == 200)
    }
  }
}
