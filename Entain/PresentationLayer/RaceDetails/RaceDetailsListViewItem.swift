//
//  RaceDetailsListViewItem.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//


import SwiftUI

struct RaceDetailsListViewItem: View {
  @StateObject private var viewModel: RaceDetailsListViewItemViewModel
  
  init(viewModel: RaceDetailsListViewItemViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    HStack(spacing: 12) {
      Image(viewModel.raceImage)
        .resizable()
        .frame(width: 40, height: 40)
        .clipShape(Circle())
      
      VStack(alignment: .leading, spacing: 4) {
        Text(viewModel.raceName)
          .font(.headline)
        
        Text(viewModel.raceCountry)
          .font(.subheadline)
          .foregroundColor(.gray)
        
        Text("\(viewModel.raceStartTime, style: .time)")
          .font(.subheadline)
          .foregroundColor(.blue)
      }
      
      Spacer()
      
      Text(viewModel.timeDifference)
        .font(.subheadline)
        .foregroundColor(.red)
    }
    .padding()
  }
}

#Preview {
  RaceDetailsListViewItem(viewModel: RaceDetailsListViewItemViewModel(
    raceImage: "horse-racing",
    raceName: "Grand Derby",
    raceCountry: "USA",
    raceStartTime: Calendar.current.date(byAdding: .minute, value: -10, to: Date())!
))
}
