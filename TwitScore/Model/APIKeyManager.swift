//
//  APIKeyManager.swift
//  TwitScore
//
//  Created by willhcodes on 7/5/23.
//


import Foundation

struct APIKeyManager {
    var apiKey: String {
        guard let plistPath = Bundle.main.path(forResource: "Secret", ofType: "plist"),
              let plistData = FileManager.default.contents(atPath: plistPath),
              let plistDictionary = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any],
              let apiKey = plistDictionary["API Key"] as? String else {
            fatalError("API Key not found in plist file")
            
        }
        return apiKey
    }
    
    var apiKeySecret: String {
        guard let plistPath = Bundle.main.path(forResource: "Secret", ofType: "plist"),
              let plistData = FileManager.default.contents(atPath: plistPath),
              let plistDictionary = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any],
              let apiKeySecret = plistDictionary["API Key Secret"] as? String else {
            fatalError("API Key not found in plist file")
            
        }
        return apiKeySecret
    }
}

