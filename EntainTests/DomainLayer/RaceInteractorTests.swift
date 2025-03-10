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

struct RaceInteractorTests {
  @Test("Successful Response Handling")
  func raceInteractorGetNextRacesSuccess() async throws {
    let mockRaceService = MockRaceService()
    let raceInteractor = RaceInteractor(raceService: mockRaceService)
    
    let mockRaceResponse = RaceResponse(
      status: 200,
      data: DataClass(
        nextToGoIDS: ["race_1", "race_2"],
        raceSummaries: [
          "race_1": RaceSummary(
            raceID: "race_1",
            raceName: "First Race",
            raceNumber: 1,
            meetingID: "meeting_1",
            meetingName: "Meeting 1",
            categoryID: "category_1",
            advertisedStart: AdvertisedStart(seconds: 1234567890),
            raceForm: nil,
            venueID: "venue_1",
            venueName: "Venue 1",
            venueState: "State 1",
            venueCountry: "Country 1"
          ),
          "race_2": RaceSummary(
            raceID: "race_2",
            raceName: "Second Race",
            raceNumber: 2,
            meetingID: "meeting_2",
            meetingName: "Meeting 2",
            categoryID: "category_2",
            advertisedStart: AdvertisedStart(seconds: 1234567891),
            raceForm: nil,
            venueID: "venue_2",
            venueName: "Venue 2",
            venueState: "State 2",
            venueCountry: "Country 2"
          )
        ]
      ),
      message: "Success"
    )
    
    mockRaceService.mockResponse = mockRaceResponse
    
    let result = try await raceInteractor.getNextRaces(count: 2)
    
    #expect(result.status == mockRaceResponse.status)
    #expect(result.data?.nextToGoIDS == mockRaceResponse.data?.nextToGoIDS)
    
    if let firstRaceID = mockRaceResponse.data?.nextToGoIDS?.first,
       let firstRaceSummary = mockRaceResponse.data?.raceSummaries?[firstRaceID] {
      #expect(result.data?.raceSummaries?[firstRaceID]?.raceName == firstRaceSummary.raceName)
      #expect(result.data?.raceSummaries?[firstRaceID]?.venueName == firstRaceSummary.venueName)
    }
  }
  
  @Test("Failure Response Handling")
  func raceInteractorGetNextRacesFailure() async {
    let mockRaceService = MockRaceService()
    let raceInteractor = RaceInteractor(raceService: mockRaceService)
    
    mockRaceService.mockError = NetworkError.requestFailed(404)
    
    await #expect(throws: NetworkError.requestFailed(404)) {
      _ = try await raceInteractor.getNextRaces(count: 10)
    }
  }
}
