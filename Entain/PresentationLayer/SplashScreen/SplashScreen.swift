//
//  SplashScreen.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 11/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//


import SwiftUI

struct SplashScreen: View {
  @State private var isActive = false
  @StateObject private var raceViewModel = RaceViewModel(interactor: RaceInteractor(raceService: RaceService()))
  
  var body: some View {
    if isActive {
      RaceView(viewModel: raceViewModel)
    } else {
      VStack {
        Image("splashScreenLogo")
          .resizable()
          .frame(height: 100)
          .foregroundColor(.blue)
          .padding()
      }
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
          withAnimation {
            isActive = true
          }
        }
      }
    }
  }
}

#Preview {
  SplashScreen()
}
