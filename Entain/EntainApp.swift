//
//  EntainApp.swift
//  Entain
//
//  Created by Chirag Chaplot on 9/3/2025.
//

import SwiftUI

@main
struct EntainApp: App {
  @StateObject private var raceViewModel = RaceViewModel(interactor: RaceInteractor(raceService: RaceService()))
  var body: some Scene {
    WindowGroup {
      RaceView(viewModel: raceViewModel)
    }
  }
}
