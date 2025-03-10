//
//  RaceViewModel.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Foundation

enum DataState<Value> {
  case loading
  case success(Value)
  case failure(String)
  case fetchAgain
}

class RaceViewModel: ObservableObject {
  private let interactor: RaceInteractorProtocol
  @Published private(set) var state: DataState<[RaceSummary]> = .loading
  private(set) var races: [RaceSummary] = []
  private(set) var errorMessage: String?
  
  init(interactor: RaceInteractorProtocol) {
    self.interactor = interactor
  }
  
  @MainActor
  func fetchRaces() {
    state = .loading
    Task {
      do {
        let raceResponse = try await interactor.getNextRaces(count: 10)
        var fetchedRaces = raceResponse.data?.nextToGoIDS?.compactMap { id in
          raceResponse.data?.raceSummaries?[id]
        } ?? []
        fetchedRaces.sort {
          guard let date1 = $0.advertisedStart?.seconds, let date2 = $1.advertisedStart?.seconds else {
            return false
          }
          return date1 < date2
        }
        self.races = fetchedRaces
        
        self.errorMessage = nil
        state = .success(fetchedRaces)
      } catch {
        self.races = []
        self.errorMessage = (error as? NetworkError)?.localizedDescription ?? "An error occurred."
        state = .failure(self.errorMessage!)
      }
    }
  }
  
  @MainActor func fetchAgain() {
    state = .fetchAgain
    fetchRaces()
  }
  
  func getRaceItemViewModel(for race: RaceSummary) -> RaceDetailsListViewItemViewModel {
    return RaceDetailsListViewItemViewModel(
      raceImage: race.raceCategory.imageName,
      raceName: race.raceName ?? "Unknown Race",
      raceCountry: race.venueCountry ?? "Unknown Country",
      raceStartTime: Date(timeIntervalSince1970: TimeInterval(race.advertisedStart?.seconds ?? 0))
    )
  }
}

extension RaceViewModel: CustomToolbarDelegate {
  func didTapFilter(selectedFilters: [RaceCategory]) {
    // TODO: - Filter
  }
  
  func didTapSearch() {
    // TODO: - Search
  }
  
  @MainActor func didTapRefresh() {
    self.fetchAgain()
  }
}
