//
//  RaceView.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//


import SwiftUI

struct RaceView: View {
  @ObservedObject var viewModel: RaceViewModel
  
  var body: some View {
    VStack {
      Text("Upcoming Races")
        .font(.largeTitle)
        .padding()
      
      List(viewModel.races, id: \.raceID) { race in
        Text(race.raceName ?? "Unknown Race")
      }
      
      if let errorMessage = viewModel.errorMessage {
        Text(errorMessage)
          .foregroundColor(.red)
          .padding()
      }
      
      Button("Fetch Next Races") {
        viewModel.fetchRaces()
      }
      .padding()
    }
    .onAppear {
      viewModel.fetchRaces()
    }
  }
}
