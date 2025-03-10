//
//  RaceViewModel.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Foundation
import Combine

class RaceViewModel: ObservableObject {
  private let interactor: RaceInteractorProtocol
  @Published private(set) var races: [RaceSummary] = []
  @Published var errorMessage: String?
  
  init(interactor: RaceInteractorProtocol) {
    self.interactor = interactor
  }
  
  @MainActor
  func fetchRaces() {
    Task {
      do {
        let raceResponse = try await interactor.getNextRaces(count: 10)
        
        self.races = raceResponse.data?.nextToGoIDS?.compactMap { id in
          raceResponse.data?.raceSummaries?[id]
        } ?? []
        
        self.errorMessage = nil
      } catch {
        self.errorMessage = (error as? NetworkError)?.localizedDescription ?? "An error occurred."
      }
    }
  }
}
