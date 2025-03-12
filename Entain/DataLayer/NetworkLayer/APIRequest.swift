//
//  APIRequest.swift
//  Warning: Contents may be more confusing than they appear.
//  Powered by caffeine and desperation.
//  Created by Chirag Chaplot on 9/3/2025.
//  Copyright © 2025 Chirag Chaplot Pvt Ltd. All rights reserved.
//
import Foundation

protocol APIRequest: Sendable {
    var path: String { get }
    var method: String { get }
    var queryParams: [String: String] { get }
    
    func buildURL() -> URL?
}
