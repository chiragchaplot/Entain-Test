//
//  RaceDetailsListViewItemViewModel.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import SwiftUI

@Observable
class RaceDetailsListViewItemViewModel {
  let raceImage: String
  let raceName: String
  let raceCountry: String
  let raceStartTime: Date
  let raceNumber: String
  private let raceID: String
  
  private let onExpire: () -> Void
  
  var timeDifference: String = ""
  
  private var timer: Timer?
  
  init(raceImage: String,
       raceName: String,
       raceCountry: String,
       raceStartTime: Date,
       raceNumber: String,
       raceID: String,
       onExpire: @escaping () -> Void) {
    self.raceImage = raceImage
    self.raceName = raceName
    self.raceCountry = raceCountry
    self.raceStartTime = raceStartTime
    self.raceNumber = raceNumber
    self.raceID = raceID
    self.onExpire = onExpire
    updateTimeDifference()
    startTimer()
  }
  
  private func updateTimeDifference() {
      let diff = Date().timeIntervalSince(raceStartTime)
      let minutes = Int(abs(diff)) / 60
      let seconds = Int(abs(diff)) % 60
      
      if diff > 0 {
          self.timeDifference = "Started \(minutes)m \(seconds)s ago"
        if seconds == 59 {
          timer?.invalidate()
          onExpire()
        }
      } else {
          self.timeDifference = "\(minutes)m \(seconds)s to go"
      }
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
