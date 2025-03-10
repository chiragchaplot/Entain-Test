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
      ForEach(RaceCategory.allCases, id: \.self) { category in
        Button(action: {
          toggleSelection(for: category)
        }) {
          HStack {
            Image(systemName: selectedFilters.contains(category) ? "checkmark.square.fill" : "square")
              .foregroundColor(.blue)
            Text(category.displayName)
              .foregroundColor(.primary)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
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
    .background(Color(.systemBackground))
    .cornerRadius(10)
    .shadow(radius: 5)
    .frame(width: 200)
  }
  
  private func toggleSelection(for category: RaceCategory) {
    if selectedFilters.contains(category) {
      selectedFilters.remove(category)
    } else {
      selectedFilters.insert(category)
    }
  }
}
