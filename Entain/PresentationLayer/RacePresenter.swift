//
//  RacePresenter.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Foundation

protocol RacePresenterProtocol {
  func fetchNextRaces()
}

class RacePresenter: ObservableObject, @preconcurrency RacePresenterProtocol {
  private let interactor: RaceInteractorProtocol
  
  @Published private(set) var races: [RaceSummary] = []
  @Published private(set) var errorMessage: String?
  
  init(interactor: RaceInteractorProtocol) {
    self.interactor = interactor
  }
  
  @MainActor
  func fetchNextRaces() {
    Task {
      do {
        let raceResponse = try await self.interactor.getNextRaces(count: 10)
        
        let fetchedRaces = raceResponse.data?.nextToGoIDS?.compactMap { id in
          raceResponse.data?.raceSummaries?[id]
        } ?? []
        
        self.races = fetchedRaces
      } catch {
        self.errorMessage = (error as? NetworkError)?.localizedDescription ?? "An error occurred."
      }
    }
  }
}
