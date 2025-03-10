//
//  RaceResponse.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 9/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Foundation

// MARK: - RaceResponse
struct RaceResponse: Decodable {
  var status: Int
  var data: DataClass?
  var message: String?
}

// MARK: - DataClass
struct DataClass: Decodable {
  var nextToGoIDS: [String]?
  var raceSummaries: [String: RaceSummary]?
  
  enum CodingKeys: String, CodingKey {
    case nextToGoIDS = "next_to_go_ids"
    case raceSummaries = "race_summaries"
  }
}

// MARK: - RaceSummary
struct RaceSummary: Decodable {
  var raceID, raceName: String?
  var raceNumber: Int?
  var meetingID, meetingName, categoryID: String?
  var advertisedStart: AdvertisedStart?
  var raceForm: RaceForm?
  var venueID, venueName, venueState, venueCountry: String?
  
  var raceCategory: RaceCategory {
    guard let categoryID = self.categoryID,
          let raceCategory = RaceCategory(rawValue: categoryID)else { return .greyhound }
    return raceCategory
  }
  
  enum CodingKeys: String, CodingKey {
    case raceID = "race_id"
    case raceName = "race_name"
    case raceNumber = "race_number"
    case meetingID = "meeting_id"
    case meetingName = "meeting_name"
    case categoryID = "category_id"
    case advertisedStart = "advertised_start"
    case raceForm = "race_form"
    case venueID = "venue_id"
    case venueName = "venue_name"
    case venueState = "venue_state"
    case venueCountry = "venue_country"
  }
}

// MARK: - AdvertisedStart
struct AdvertisedStart: Decodable {
  var seconds: Int?
}

// MARK: - RaceForm
struct RaceForm: Decodable {
  var distance: Int?
  var distanceType: DistanceType?
  var distanceTypeID: String?
  var trackCondition: DistanceType?
  var trackConditionID: String?
  var weather: DistanceType?
  var weatherID, raceComment, additionalData: String?
  var generated: Int?
  var silkBaseURL: SilkBaseURL?
  var raceCommentAlternative: String?
  
  enum CodingKeys: String, CodingKey {
    case distance
    case distanceType = "distance_type"
    case distanceTypeID = "distance_type_id"
    case trackCondition = "track_condition"
    case trackConditionID = "track_condition_id"
    case weather
    case weatherID = "weather_id"
    case raceComment = "race_comment"
    case additionalData = "additional_data"
    case generated
    case silkBaseURL = "silk_base_url"
    case raceCommentAlternative = "race_comment_alternative"
  }
}

// MARK: - DistanceType
struct DistanceType: Decodable {
  var id, name, shortName, iconURI: String?
  
  enum CodingKeys: String, CodingKey {
    case id, name
    case shortName = "short_name"
    case iconURI = "icon_uri"
  }
}

enum SilkBaseURL: String, Decodable {
  case drr38Safykj6SCloudfrontNet = "drr38safykj6s.cloudfront.net"
}
