//
//  RaceView.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import SwiftUI

struct RaceView: View {
  @State var viewModel: RaceViewModel
  
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
            RaceDetailsListViewItem(viewModel: viewModel.getRaceItemViewModel(for: race))
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
      .toolbar {
        CustomToolbar(delegate: viewModel)
      }
      .onAppear {
        if case .loading = viewModel.state {
          viewModel.fetchRaces()
        }
      }
    }
    .navigationViewStyle(.stack)
  }
}

