//
//  MockNetworkManager.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 10/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//

import Foundation
@testable import Entain

final class MockNetworkManager: NetworkService {
  private actor State {
    var capturedURL: URL?
    var capturedResponseTypeName: String?
    var shouldFailWithError: NetworkError?
    var mockJSONData: Data?
    
    func setCapturedURL(_ url: URL?) {
      capturedURL = url
    }
    
    func setCapturedResponseType<T>(_ type: T.Type) {
      capturedResponseTypeName = String(describing: type)
    }
    
    func setMockJSONData(jsonData: Data) {
      mockJSONData = jsonData
      shouldFailWithError = nil
    }
    
    func setError(error: NetworkError) {
      shouldFailWithError = error
      mockJSONData = nil
    }
  }
  
  private let state = State()
  
  func setupSuccess(with jsonData: Data) async {
    await state.setMockJSONData(jsonData: jsonData)
  }
  
  func setupFailure(with error: NetworkError) async {
    await state.setError(error: error)
  }
  
  func getCapturedURL() async -> URL? {
    return await state.capturedURL
  }
  
  func isResponseTypeEqual<T>(to type: T.Type) async -> Bool {
    let typeName = String(describing: type)
    let capturedName = await state.capturedResponseTypeName
    return typeName == capturedName
  }
  
  func fetch<T: Decodable>(url: URL?, responseType: T.Type) async throws -> T {
    await state.setCapturedURL(url)
    await state.setCapturedResponseType(responseType)
    
    guard let url = url else {
      throw NetworkError.invalidURL
    }
    
    if let error = await state.shouldFailWithError {
      throw error
    }
    
    guard let jsonData = await state.mockJSONData else {
      throw NetworkError.noData
    }
    
    do {
      return try JSONDecoder().decode(T.self, from: jsonData)
    } catch {
      throw NetworkError.decodingFailed(error.localizedDescription)
    }
  }
}
