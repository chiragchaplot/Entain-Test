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

struct CustomToolbar: ToolbarContent {
  weak var delegate: CustomToolbarDelegate?
  @State private var showFilterMenu = false
  @State private var selectedFilters: Set<RaceCategory> = []
  
  var body: some ToolbarContent {
    ToolbarItemGroup(placement: .navigationBarTrailing) {
      
      Button(action: {
        delegate?.didTapSearch()
      }) {
        Image(systemName: "magnifyingglass")
          .foregroundColor(.white)
      }
      .accessibilityIdentifier("SearchButton")
      
      Button(action: {
        showFilterMenu.toggle()
      }) {
        Image(systemName: "line.3.horizontal.decrease.circle")
          .foregroundColor(.white)
      }
      .popover(isPresented: $showFilterMenu, arrowEdge: .top) {
        RaceFilterView(
          selectedFilters: $selectedFilters,
          isPresented: $showFilterMenu
        ) { filters in
          delegate?.didTapFilter(selectedFilters: filters)
        }
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
  }
}
