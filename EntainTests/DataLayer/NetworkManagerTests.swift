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

@Suite("NetworkManager Tests")
struct NetworkManagerTests {
  
  func createMockSession(
    data: Data? = nil,
    statusCode: Int = 200,
    error: Error? = nil
  ) -> MockURLSession {
    let mock = MockURLSession()
    mock.data = data
    
    let url = URL(string: "https://example.com")!
    mock.response = HTTPURLResponse(
      url: url,
      statusCode: statusCode,
      httpVersion: "HTTP/1.1",
      headerFields: nil
    )
    
    mock.error = error
    return mock
  }
  
  func createValidJSON() -> Data {
        """
        {
            "id": 123,
            "name": "Test Name"
        }
        """.data(using: .utf8)!
  }
  
  func createInvalidJSON() -> Data {
        """
        {
            "id": 123,
            "name":
        }
        """.data(using: .utf8)!
  }
  
  @Test("fetch successfully decodes valid JSON response")
  func testSuccessfulFetch() async throws {
    let mockData = createValidJSON()
    let mockSession = createMockSession(data: mockData)
    let networkManager = NetworkManager(session: mockSession)
    let url = URL(string: "https://example.com/api/data")
    
    let result = try await networkManager.fetch(url: url, responseType: MockModel.self)
    
    let expectedModel = MockModel(id: 123, name: "Test Name")
    #expect(result == expectedModel)
  }
  
  @Test("fetch throws invalidURL error when URL is nil")
  func testNilURL() async {
    let mockSession = createMockSession(data: createValidJSON())
    let networkManager = NetworkManager(session: mockSession)
    
    do {
      _ = try await networkManager.fetch(url: nil, responseType: MockModel.self)
      #expect(false, "Expected invalidURL error but no error was thrown")
    } catch let error as NetworkError {
      #expect(error == NetworkError.invalidURL)
    } catch {
      #expect(false, "Expected NetworkError.invalidURL but got \(error)")
    }
  }
  
  @Test("fetch throws invalidURL error for malformed URL")
  func testInvalidURL() async {
    let mockSession = createMockSession(data: createValidJSON())
    let networkManager = NetworkManager(session: mockSession)
    let invalidURL = URL(string: "invalid-url")
    
    do {
      _ = try await networkManager.fetch(url: invalidURL, responseType: MockModel.self)
      #expect(false, "Expected invalidURL error but no error was thrown")
    } catch let error as NetworkError {
      #expect(error == NetworkError.invalidURL)
    } catch {
      #expect(false, "Expected NetworkError.invalidURL but got \(error)")
    }
  }
  
  @Test("fetch throws requestFailed error for non-2xx status codes")
  func testNon200Response() async {
    let mockSession = createMockSession(data: createValidJSON(), statusCode: 404)
    let networkManager = NetworkManager(session: mockSession)
    let url = URL(string: "https://example.com/api/data")
    
    do {
      _ = try await networkManager.fetch(url: url, responseType: MockModel.self)
      #expect(false, "Expected requestFailed error but no error was thrown")
    } catch let error as NetworkError {
      #expect(error == NetworkError.requestFailed(404))
    } catch {
      #expect(false, "Expected NetworkError.requestFailed but got \(error)")
    }
  }
  
  @Test("fetch throws noData error when response data is empty")
  func testEmptyData() async {
    let emptyData = Data()
    let mockSession = createMockSession(data: emptyData)
    let networkManager = NetworkManager(session: mockSession)
    let url = URL(string: "https://example.com/api/data")
    
    do {
      _ = try await networkManager.fetch(url: url, responseType: MockModel.self)
      #expect(false, "Expected noData error but no error was thrown")
    } catch let error as NetworkError {
      #expect(error == NetworkError.noData)
    } catch {
      #expect(false, "Expected NetworkError.noData but got \(error)")
    }
  }
  
  @Test("fetch throws decodingFailed error when JSON is invalid")
  func testInvalidJSON() async {
    let invalidJSON = createInvalidJSON()
    let mockSession = createMockSession(data: invalidJSON)
    let networkManager = NetworkManager(session: mockSession)
    let url = URL(string: "https://example.com/api/data")
    
    do {
      _ = try await networkManager.fetch(url: url, responseType: MockModel.self)
      #expect(false, "Expected decodingFailed error but no error was thrown")
    } catch let error as NetworkError {
      #expect(error.localizedEquatable(to: NetworkError.decodingFailed("")))
    } catch {
      #expect(false, "Expected NetworkError.decodingFailed but got \(error)")
    }
  }
  
  @Test("fetch propagates underlying network errors as unknown errors")
  func testUnderlyingNetworkError() async {
    let underlyingError = NSError(domain: "Test", code: 123)
    let mockSession = createMockSession(error: underlyingError)
    let networkManager = NetworkManager(session: mockSession)
    let url = URL(string: "https://example.com/api/data")
    
    do {
      _ = try await networkManager.fetch(url: url, responseType: MockModel.self)
      #expect(false, "Expected unknown error but no error was thrown")
    } catch let error as NetworkError {
      switch error {
      case .unknown(let wrappedError):
        let nsError = wrappedError as NSError
        #expect(nsError.domain == "Test")
        #expect(nsError.code == 123)
      default:
        #expect(false, "Expected NetworkError.unknown but got \(error)")
      }
    } catch {
      #expect(false, "Expected NetworkError.unknown but got \(error)")
    }
  }
}

extension NetworkError {
  func localizedEquatable(to other: NetworkError) -> Bool {
    switch (self, other) {
    case (.decodingFailed, .decodingFailed):
      return true
    default:
      return self == other
    }
  }
}
