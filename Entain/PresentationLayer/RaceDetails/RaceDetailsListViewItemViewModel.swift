//
//  RaceDetailsListViewItemViewModel.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import SwiftUI

class RaceDetailsListViewItemViewModel: ObservableObject {
  let raceImage: String
  let raceName: String
  let raceCountry: String
  let raceStartTime: Date
  
  @Published var timeDifference: String = ""
  
  private var timer: Timer?
  
  init(raceImage: String, raceName: String, raceCountry: String, raceStartTime: Date) {
    self.raceImage = raceImage
    self.raceName = raceName
    self.raceCountry = raceCountry
    self.raceStartTime = raceStartTime
    updateTimeDifference()
    startTimer()
  }
  
  private func updateTimeDifference() {
    let diff = Date().timeIntervalSince(raceStartTime)
    let minutes = Int(diff) / 60
    let seconds = Int(diff) % 60
    self.timeDifference = "\(minutes)m \(seconds)s ago"
  }
  
  private func startTimer() {
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
      self?.updateTimeDifference()
    }
  }
  
  deinit {
    timer?.invalidate()
  }
}
