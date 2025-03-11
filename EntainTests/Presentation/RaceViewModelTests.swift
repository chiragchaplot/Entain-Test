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

class RaceViewModelTests {
  let dummyRaceResponse = RaceResponse(
      status: 200,
      data:  DataClass(
        nextToGoIDS: ["1", "2"],
        raceSummaries: [
            "1": RaceSummary(
              raceID: "1",
              raceName: "Sample Race 1",
              raceNumber: 1,
              meetingID: "M1",
              meetingName: "Sample Meeting 1",
              categoryID: "greyhound",
              advertisedStart: AdvertisedStart(seconds: 1200),
              raceForm: nil,
              venueID: "V1",
              venueName: "Sample Venue 1",
              venueState: "Sample State",
              venueCountry: "Australia"
          ),
            "2": RaceSummary(
              raceID: "2",
              raceName: "Sample Race 2",
              raceNumber: 2,
              meetingID: "M2",
              meetingName: "Sample Meeting 2",
              categoryID: "harness",
              advertisedStart: AdvertisedStart(seconds: 1500),
              raceForm: nil,
              venueID: "V2",
              venueName: "Sample Venue 2",
              venueState: "Sample State",
              venueCountry: "USA"
          )
        ]
    ),
      message: "Success"
  )
  

  @Test("Fetch Races Failure")
  func testRacesFailure() async throws {
    var mockInteractor: MockRaceInteractor! = MockRaceInteractor()
    var viewModel = RaceViewModel(interactor: mockInteractor)
    mockInteractor.mockResult = .failure(NetworkError.decodingFailed("Something went wrong"))
    await viewModel.fetchRaces()
  }
  
  @Test("Fetch Races Success")
  func testRacesSuccess() async throws {
    var mockInteractor: MockRaceInteractor! = MockRaceInteractor()
    var viewModel = RaceViewModel(interactor: mockInteractor)
    mockInteractor.mockResult = .success(self.dummyRaceResponse)
    await viewModel.fetchRaces()
  }
}

class MockRaceInteractor: RaceInteractorProtocol {
  var mockResult: Result<RaceResponse, Error>?
  
  func getNextRaces(count: Int) async throws -> RaceResponse {
    guard let result = mockResult else {
      fatalError("Mock result not set")
    }
    
    switch result {
    case .success(let response):
      return response
    case .failure(let error):
      throw error
    }
  }
}

