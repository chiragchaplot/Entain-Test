//
//  NavigationBarView.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//
import SwiftUI
import Combine

struct NavigationBarView: View {
  @ObservedObject var viewModel: RaceViewModel
  
  var body: some View {
    ZStack {
      Color.orange
      
      HStack {
        Text("Next to go")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.white)
        
        Spacer()
        
        HStack(spacing: 20) {
          Button(action: {
            viewModel.refreshTapped()
          }) {
            Image(systemName: "arrow.clockwise")
              .foregroundColor(.white)
          }
          
          Button(action: {
            viewModel.filterTapped()
          }) {
            Image(systemName: "line.horizontal.3.decrease.circle")
              .foregroundColor(.white)
          }
          
          Button(action: {
            viewModel.searchTapped()
          }) {
            Image(systemName: "magnifyingglass")
              .foregroundColor(.white)
          }
        }
      }
      .padding()
    }
    .frame(height: 60)
    .edgesIgnoringSafeArea(.top)
  }
}
