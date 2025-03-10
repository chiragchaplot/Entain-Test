//
//  NetworkManagerTests.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Testing
import Foundation
@testable import Entain

struct NetworkManagerTests {
  @Test
  func networkManagerFetchSuccessfulResponse() async throws {
    let mockURLSession = MockURLSession()
    let networkManager = NetworkManager(session: mockURLSession)
    let expectedData = TestModel(id: 1, name: "Test")
    let jsonData = try JSONEncoder().encode(expectedData)
    mockURLSession.data = jsonData
    mockURLSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    let result: TestModel = try await networkManager.fetch(url: URL(string: "https://example.com"), responseType: TestModel.self)
    
    #expect(result.id == expectedData.id)
    #expect(result.name == expectedData.name)
  }
  
  @Test
  func networkManagerFetchInvalidURL() async {
    let networkManager = NetworkManager(session: MockURLSession())
    
    await #expect(throws: NetworkError.invalidURL) {
      try await networkManager.fetch(url: nil, responseType: TestModel.self)
    }
  }
  
  @Test
  func networkManagerFetchRequestFailed() async {
    let mockURLSession = MockURLSession()
    let networkManager = NetworkManager(session: mockURLSession)
    mockURLSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)
    
    await #expect(throws: NetworkError.requestFailed(404)) {
      try await networkManager.fetch(url: URL(string: "https://example.com"), responseType: TestModel.self)
    }
  }
  
  @Test
  func networkManagerFetchNoData() async {
    let mockURLSession = MockURLSession()
    let networkManager = NetworkManager(session: mockURLSession)
    mockURLSession.data = Data()
    mockURLSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    await #expect(throws: NetworkError.noData) {
      try await networkManager.fetch(url: URL(string: "https://example.com"), responseType: TestModel.self)
    }
  }
  
  @Test
  func networkManagerFetchDecodingFailed() async throws {
    let mockURLSession = MockURLSession()
    let networkManager = NetworkManager(session: mockURLSession)
    let invalidJSONData = "{ \"invalid\": \"json\" }".data(using: .utf8)!
    mockURLSession.data = invalidJSONData
    mockURLSession.response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    await #expect(throws: NetworkError.self) {
      _ = try await networkManager.fetch(url: URL(string: "https://example.com"), responseType: TestModel.self)
    }
  }

  @Test
  func networkManagerFetchUnknownError() async throws {
    let mockURLSession = MockURLSession()
    let networkManager = NetworkManager(session: mockURLSession)
    mockURLSession.error = NetworkError.unknown(URLError(.notConnectedToInternet))
    
    do {
      _ = try await networkManager.fetch(url: URL(string: "https://example.com"), responseType: TestModel.self)
      #expect(false, "Expected NetworkError.unknown, but no error was thrown")
    } catch {
      #expect(error is NetworkError)
      #expect(error as? NetworkError == .unknown(URLError(.notConnectedToInternet)))
    }
  }
}

struct TestModel: Codable, Equatable {
  let id: Int
  let name: String
}
