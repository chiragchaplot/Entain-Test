//
//  CustomToolbar.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import SwiftUI

protocol CustomToolbarDelegate: AnyObject {
  func didTapSearch()
  @MainActor func didTapRefresh()
  func didTapFilter(selectedFilters: [RaceCategory])
}

struct CustomToolbar: View {
  weak var delegate: CustomToolbarDelegate?
  @State private var showFilterMenu = false
  @State private var selectedFilters: Set<RaceCategory> = [.greyhound, .harness, .horse]
  
  var body: some View {
    ZStack {
      HStack {
        Button(action: {
          delegate?.didTapSearch()
        }) {
          Image(systemName: "magnifyingglass")
            .foregroundColor(.white)
        }
        .accessibilityIdentifier("SearchButton")
        
        Button(action: {
          withAnimation {
            showFilterMenu.toggle()
          }
        }) {
          Image(systemName: "line.3.horizontal.decrease.circle")
            .foregroundColor(.white)
        }
        .accessibilityIdentifier("FilterButton")
        
        Button(action: {
          delegate?.didTapRefresh()
        }) {
          Image(systemName: "arrow.clockwise")
            .foregroundColor(.white)
        }
        .accessibilityIdentifier("RefreshButton")
      }
      .padding()
      
      .sheet(isPresented: $showFilterMenu) {
        RaceFilterView(
          selectedFilters: $selectedFilters,
          isPresented: $showFilterMenu
        ) { filters in
          delegate?.didTapFilter(selectedFilters: filters)
        }
        .background(Color.clear)
      }
    }
  }
}
