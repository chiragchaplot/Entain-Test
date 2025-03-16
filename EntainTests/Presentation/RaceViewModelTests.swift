//
//  RaceViewModelTests.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 11/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Testing
@testable import Entain
import Foundation

@MainActor
@Suite("RaceViewModel Tests")
struct RaceViewModelTests {
  @Test("Initial state should be loading")
  func initialStateLoading() {
    let mockResponse = RaceResponse(
      status: 200,
      data: nil,
      message: nil
    )
    
    let mockInteractor = MockRaceInteractor(mockResponse: mockResponse)
    let viewModel = RaceViewModel(interactor: mockInteractor)
    
    switch viewModel.state {
    case .loading:
      #expect(true)
    default:
      #expect(Bool(false), "State should be loading")
    }
    #expect(viewModel.races.isEmpty)
  }
  
  @Test("Fetch races should update state and races")
  func fetchRacesSuccessful() async throws {
    let mockRaces = [
      createMockRaceSummary(id: "1", category: .horse),
      createMockRaceSummary(id: "2", category: .greyhound),
      createMockRaceSummary(id: "3", category: .harness),
      createMockRaceSummary(id: "4", category: .horse),
      createMockRaceSummary(id: "5", category: .greyhound),
      createMockRaceSummary(id: "6", category: .harness),
      createMockRaceSummary(id: "7", category: .horse),
      createMockRaceSummary(id: "8", category: .greyhound),
      createMockRaceSummary(id: "9", category: .harness)
    ]
    let mockResponse = RaceResponse(
      status: 200,
      data: DataClass(
        nextToGoIDS: mockRaces.map { $0.raceID! },
        raceSummaries: Dictionary(uniqueKeysWithValues: mockRaces.compactMap {
          guard let id = $0.raceID else { return nil }
          return (id, $0)
        })
      ),
      message: nil
    )
    let mockInteractor = MockRaceInteractor(mockResponse: mockResponse)
    let viewModel = RaceViewModel(interactor: mockInteractor)
    
    viewModel.fetchRaces(count: 9)
    
    try await Task.sleep(nanoseconds: 100_000_000)
    
    #expect(viewModel.races.count == 9)
    switch viewModel.state {
    case .success(let races):
      #expect(true)
      #expect(races.count == 5)
    default:
      #expect(Bool(false), "Races should have loaded")
    }
  }
  
  @Test("Fetch races error should update state")
  func fetchRacesError() async throws {
    let mockInteractor = MockRaceInteractor(mockError: NetworkError.noData)
    let viewModel = RaceViewModel(interactor: mockInteractor)
    
    viewModel.fetchRaces()
    
    try await Task.sleep(nanoseconds: 100_000_000)
    
    #expect(viewModel.races.isEmpty)
    switch viewModel.state {
    case .failure(let string):
      #expect(true)
    default:
      #expect(Bool(false))
    }
  }
  
  @Test("Get race item view model")
  func getRaceItemViewModel() {
    let mockRace = createMockRaceSummary(
      id: "1",
      category: .horse,
      startTime: 1741496400
    )
    let mockInteractor = MockRaceInteractor()
    let viewModel = RaceViewModel(interactor: mockInteractor)
    
    let raceItemVM = viewModel.getRaceItemViewModel(for: mockRace)
    
    #expect(raceItemVM.raceName == "Mock Meeting")
    #expect(raceItemVM.raceCountry == "Mock Country")
  }
}

func createMockRaceSummary(
  id: String,
  category: RaceCategory,
  startTime: Int = 0
) -> RaceSummary {
  RaceSummary(
    raceID: id,
    raceName: "Mock Race",
    raceNumber: 1,
    meetingID: "meeting1",
    meetingName: "Mock Meeting",
    categoryID: category.rawValue,
    advertisedStart: AdvertisedStart(seconds: startTime),
    raceForm: nil,
    venueID: "venue1",
    venueName: "Mock Venue",
    venueState: "Mock State",
    venueCountry: "Mock Country"
  )
}
