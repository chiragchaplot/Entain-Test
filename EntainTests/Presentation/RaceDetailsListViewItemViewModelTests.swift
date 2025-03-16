//
//  RaceDetailsListViewItemViewModelTests.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 16/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Testing
import Foundation
@testable import Entain

@Suite("RaceDetailsListViewItemViewModel Tests")
struct RaceDetailsListViewItemViewModelTests {
  @Test("Initialization sets correct properties")
  func initializationTest() {
    let mockDate = Date(timeIntervalSince1970: 1741496400)
    var expireCalled = false
    
    let viewModel = RaceDetailsListViewItemViewModel(
      raceImage: "horse_icon",
      raceName: "Test Race",
      raceCountry: "AUS",
      raceStartTime: mockDate,
      raceNumber: "R1",
      raceID: "race_1",
      onExpire: { expireCalled = true }
    )
    
    #expect(viewModel.raceImage == "horse_icon")
    #expect(viewModel.raceName == "Test Race")
    #expect(viewModel.raceCountry == "AUS")
    #expect(viewModel.raceStartTime == mockDate)
    #expect(viewModel.raceNumber == "R1")
  }
  
  @Test("Time difference calculation for future race")
  func futureDateTimeDifference() {
    let futureDate = Date(timeIntervalSinceNow: 120)
    var expireCalled = false
    
    let viewModel = RaceDetailsListViewItemViewModel(
      raceImage: "horse_icon",
      raceName: "Future Race",
      raceCountry: "AUS",
      raceStartTime: futureDate,
      raceNumber: "R1",
      raceID: "race_1",
      onExpire: { expireCalled = true }
    )
    
    #expect(viewModel.timeDifference.contains("to go"))
  }
  
  @Test("Time difference calculation for past race")
  func pastDateTimeDifference() {
    let pastDate = Date(timeIntervalSinceNow: -120)
    var expireCalled = false
    
    let viewModel = RaceDetailsListViewItemViewModel(
      raceImage: "horse_icon",
      raceName: "Past Race",
      raceCountry: "AUS",
      raceStartTime: pastDate,
      raceNumber: "R1",
      raceID: "race_1",
      onExpire: { expireCalled = true }
    )
    
    #expect(viewModel.timeDifference.contains("ago"))
  }
  
  @Test("Expire callback triggers when race starts")
  func expireCallbackTest() async throws {
    let pastDate = Date(timeIntervalSinceNow: -59)
    var expireCalled = false
    
    let viewModel = RaceDetailsListViewItemViewModel(
      raceImage: "horse_icon",
      raceName: "Expiring Race",
      raceCountry: "AUS",
      raceStartTime: pastDate,
      raceNumber: "R1",
      raceID: "race_1",
      onExpire: { expireCalled = true }
    )
    
    try await Task.sleep(for: .seconds(2))
    
    #expect(expireCalled == true)
  }
}
