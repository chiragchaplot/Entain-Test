//
//  RaceDetailsListViewItem.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//
    

import SwiftUI

struct RaceDetailsListViewItem: View {
    let raceImage: String
    let raceName: String
    let raceCountry: String
    let raceStartTime: Date
    
    var timeDifference: String {
        let diff = Date().timeIntervalSince(raceStartTime)
        let minutes = Int(diff) / 60
        let seconds = Int(diff) % 60
        return "\(minutes)m \(seconds)s ago"
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(raceImage)
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                
            VStack(alignment: .leading, spacing: 4) {
                Text(raceName)
                    .font(.headline)
                
                Text(raceCountry)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("\(raceStartTime, style: .time)")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Text(timeDifference)
                .font(.subheadline)
                .foregroundColor(.red)
        }
        .padding()
    }
}

#Preview {
    RaceDetailsListViewItem(
        raceImage: "horse_race",
        raceName: "Grand Derby",
        raceCountry: "USA",
        raceStartTime: Calendar.current.date(byAdding: .minute, value: -10, to: Date())!
    )
}
