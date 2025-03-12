//
//  RaceViewModel.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Foundation

enum DataState {
  case loading
  case success([RaceSummary])
  case failure(String)
  case fetchAgain
}

@Observable @MainActor
class RaceViewModel {
  private let interactor: RaceInteractorProtocol
  private(set) var state: DataState = .loading
  private(set) var races: [RaceSummary] = []
  private(set) var errorMessage: String?
  private var currentFilters: [RaceCategory] = [.greyhound, .harness, .horse]
  private var lastFetchCount = 10
  
  init(interactor: RaceInteractorProtocol) {
    self.interactor = interactor
  }
  
  /// Fetches races from the interactor
  func fetchRaces(count: Int = 10) {
    state = .loading
    Task {
      do {
        let raceResponse = try await interactor.getNextRaces(count: count)
        updateRaces(with: raceResponse, append: false)
      } catch {
        handleFetchError(error)
      }
    }
  }
  
  /// Processes and updates the races
  private func updateRaces(with raceResponse: RaceResponse, append: Bool) {
    var fetchedRaces = raceResponse.data?.nextToGoIDS?.compactMap { id in
      raceResponse.data?.raceSummaries?[id]
    } ?? []
    
    fetchedRaces.sort {
      guard let date1 = $0.advertisedStart?.seconds, let date2 = $1.advertisedStart?.seconds else {
        return false
      }
      return date1 < date2
    }
    
    if append {
      let newRaces = fetchedRaces.filter { newRace in
        !races.contains(where: { $0.raceID == newRace.raceID })
      }
      self.races.append(contentsOf: newRaces)
    } else {
      self.races = fetchedRaces
    }
    
    self.errorMessage = nil
    applyFilters()
  }
  
  
  /// Handles fetch errors
  private func handleFetchError(_ error: Error) {
    self.races = []
    self.errorMessage = (error as? NetworkError)?.localizedDescription ?? "An error occurred."
    state = .failure(self.errorMessage!)
  }
  
  /// Ensures there are at least 5 races available after filtering
  private func ensureMinimumRaces() {
    let filteredRaces = getFilteredRaces()
    if filteredRaces.count < 5 {
      lastFetchCount *= 2
      fetchRaces(count: lastFetchCount)
    } else {
      lastFetchCount = 10
      state = .success(Array(filteredRaces.prefix(10)))
    }
  }
  
  /// Applies filters and ensures minimum races
  private func applyFilters() {
    ensureMinimumRaces()
  }
  
  /// Returns races filtered by current category selection
  private func getFilteredRaces() -> [RaceSummary] {
    return currentFilters.isEmpty ? races : races.filter { currentFilters.contains($0.raceCategory) }
  }
  
  /// Called when the user taps refresh
  func fetchAgain() {
    state = .fetchAgain
    fetchRaces()
  }
  
  /// Updates filters when user selects a filter
  func updateFilters(_ selectedFilters: [RaceCategory]) {
    currentFilters = selectedFilters
    applyFilters()
  }
  
  func getRaceItemViewModel(for race: RaceSummary) -> RaceDetailsListViewItemViewModel {
    let raceNumber = "R\(race.raceNumber ?? 0)"
    let raceCountry = race.venueCountry ?? "Unknown Country"
    let raceName = race.meetingName ?? "Unknown Race"
    return RaceDetailsListViewItemViewModel(
      raceImage: race.raceCategory.imageName,
      raceName: raceName,
      raceCountry: raceCountry,
      raceStartTime: Date(timeIntervalSince1970: TimeInterval(race.advertisedStart?.seconds ?? 0)),
      raceNumber: raceNumber
    )
  }
}

extension RaceViewModel: CustomToolbarDelegate {
  func didTapFilter(selectedFilters: [RaceCategory]) {
    updateFilters(selectedFilters)
  }
  
  func didTapSearch() {
    // TODO: - Implement search functionality
  }
  
  func didTapRefresh() {
    fetchAgain()
  }
}
