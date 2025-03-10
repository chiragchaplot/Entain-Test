//
//  RaceView.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import SwiftUI
import Combine

extension UINavigationBar {
  static func configureNavigationBar() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(Color.orange)
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
  }
}

struct RaceView: View {
  @ObservedObject var viewModel: RaceViewModel
  
  init(viewModel: RaceViewModel) {
    self.viewModel = viewModel
    UINavigationBar.configureNavigationBar()
  }
  
  var body: some View {
    NavigationView {
      VStack {
        switch viewModel.state {
        case .loading:
          ProgressView()
        case .success(let races):
          List(races, id: \.raceID) { race in
            Text(race.raceName ?? "Unknown Race")
          }
          .padding(.top, 16)
        case .failure(let errorMessage):
          Text(errorMessage)
            .foregroundColor(.red)
            .padding()
        case .fetchAgain:
          ProgressView()
          Text("Fetching Races Again...")
            .padding()
        }
        
        Button(action: {
          viewModel.fetchAgain()
        }, label: {
          Text("Fetch Next Races")
        })
        .padding()
      }
      .navigationTitle("Next to go")
      .onAppear {
        if case .loading = viewModel.state {
          viewModel.fetchRaces()
        }
      }
    }
    .navigationViewStyle(.stack)
  }
}

