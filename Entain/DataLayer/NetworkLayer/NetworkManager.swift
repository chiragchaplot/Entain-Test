//
//  NetworkManager.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 9/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Foundation

enum NetworkError: Error, Equatable {
  case invalidURL
  case requestFailed(Int)
  case noData
  case decodingFailed(String)
  case internetUnavailable
  case unknown(Error)
  
  static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
    switch (lhs, rhs) {
    case (.invalidURL, .invalidURL),
      (.noData, .noData),
      (.internetUnavailable, .internetUnavailable):
      return true
    case let (.requestFailed(code1), .requestFailed(code2)):
      return code1 == code2
    case let (.decodingFailed(message1), .decodingFailed(message2)):
      return message1 == message2
    case let (.unknown(error1), .unknown(error2)):
      return error1.localizedDescription == error2.localizedDescription
    default:
      return false
    }
  }
}

protocol URLSessionProtocol {
  /// Asynchronously retrieves data for a given URL request
  /// - Parameter request: URLRequest to fetch data from
  /// - Returns: A tuple of retrieved data and response
  /// - Throws: Any errors encountered during data retrieval
  func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

protocol NetworkService: Sendable {
  /// Fetches and decodes a network response of a specified Decodable type
  /// - Parameters:
  ///   - url: Optional URL to fetch data from
  ///   - responseType: Type of Decodable response to decode
  /// - Returns: Decoded object of specified type
  /// - Throws: NetworkError if any stage of fetch or decode fails
  func fetch<T: Decodable>(url: URL?, responseType: T.Type) async throws -> T
}

final class NetworkManager: NetworkService, @unchecked Sendable {
  private let session: URLSessionProtocol
  
  init(session: URLSessionProtocol = URLSession.shared) {
    self.session = session
  }
  
  func fetch<T: Decodable>(url: URL?, responseType: T.Type) async throws -> T {
    guard let url = url,
          URLComponents(url: url, resolvingAgainstBaseURL: false) != nil,
          url.absoluteString.range(of: "^[a-zA-Z0-9+.-]+://", options: .regularExpression) != nil else {
      throw NetworkError.invalidURL
    }
    
    do {
      let (data, response) = try await session.data(for: URLRequest(url: url))
      
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
      } catch {
        throw NetworkError.decodingFailed(error.localizedDescription)
      }
    } catch let networkError as NetworkError {
      throw networkError
    } catch {
      throw NetworkError.unknown(error)
    }
  }
}
