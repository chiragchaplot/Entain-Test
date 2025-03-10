//
//  NetworkManager.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 9/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {
  case invalidURL
  case requestFailed(Int) // HTTP status codes
  case noData
  case decodingFailed(String)
  case internetUnavailable
  case unknown(Error)
  
  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "The URL is invalid."
    case .requestFailed(let statusCode):
      return "Request failed with status code \(statusCode)."
    case .noData:
      return "No data was received from the server."
    case .decodingFailed(let error):
      return "Failed to decode the response: \(error)"
    case .internetUnavailable:
      return "The internet connection appears to be offline."
    case .unknown(let error):
      return error.localizedDescription.isEmpty ? "An unknown error occurred" : "\(error.localizedDescription)"
    }
  }
}

protocol NetworkService {
  func fetch<T: Decodable>(url: URL?, responseType: T.Type) async throws -> T
}

class NetworkManager: NetworkService {
  private let urlSession: URLSession
  
  init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }
  
  func fetch<T: Decodable>(url: URL?, responseType: T.Type) async throws -> T {
    // Validate the URL
    guard let url = url,
          URLComponents(url: url, resolvingAgainstBaseURL: false) != nil,
          url.absoluteString.range(of: "^[a-zA-Z0-9+.-]+://", options: .regularExpression) != nil else {
      throw NetworkError.invalidURL
    }
    
    do {
      let (data, response) = try await urlSession.data(for: URLRequest(url: url))
      
      guard let httpResponse = response as? HTTPURLResponse else {
        throw NetworkError.unknown(URLError(.badServerResponse))
      }
      
      guard (200...299).contains(httpResponse.statusCode) else {
        throw NetworkError.requestFailed(httpResponse.statusCode)
      }
      
      guard !data.isEmpty else {
        throw NetworkError.noData
      }
      
      do {
        let decodedObject = try JSONDecoder().decode(T.self, from: data)
        return decodedObject
      } catch let decodingError as DecodingError {
        throw NetworkError.decodingFailed(decodingError.localizedDescription)
      }
    } catch let urlError as URLError {
      if urlError.code == .notConnectedToInternet {
        throw NetworkError.internetUnavailable
      }
      throw NetworkError.unknown(urlError)
    } catch {
      throw NetworkError.unknown(error)
    }
  }
}
