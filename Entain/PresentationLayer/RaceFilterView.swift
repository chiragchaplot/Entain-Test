//
//  RaceFilterView.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//


import SwiftUI

struct RaceFilterView: View {
  @Binding var selectedFilters: Set<RaceCategory>
  @Binding var isPresented: Bool
  var onApply: ([RaceCategory]) -> Void
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("Filter Races")
        .font(.headline)
        .padding(.bottom, 5)
      
      ForEach(RaceCategory.allCases) { category in
        HStack {
          Image(systemName: selectedFilters.contains(category) ? "checkmark.square.fill" : "square")
            .foregroundColor(.blue)
            .onTapGesture {
              toggleSelection(for: category)
            }
          Text(category.rawValue)
            .onTapGesture {
              toggleSelection(for: category)
            }
        }
      }
      
      Button("Apply") {
        onApply(Array(selectedFilters))
        isPresented = false
      }
      .frame(maxWidth: .infinity)
      .padding()
      .background(Color.blue)
      .foregroundColor(.white)
      .cornerRadius(8)
    }
    .padding()
    .frame(width: 200)
    .background(Color(.systemBackground))
    .cornerRadius(10)
    .shadow(radius: 5)
  }
  
  private func toggleSelection(for category: RaceCategory) {
    if selectedFilters.contains(category) {
      selectedFilters.remove(category)
    } else {
      selectedFilters.insert(category)
    }
  }
}
