//
//  APIKey.swift
//  FunFact
//
//  Created by Justin Glazer on 6/30/25.
//

import Foundation

enum APIKey {
    static var `default`: String {
        guard let filePath = Bundle.main.path(forResource: "AI-Info", ofType: "plist")
        else {
            fatalError("Could not find file")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_Key") as? String else {
            fatalError("Could not find key")
        }
        if value.starts(with: "_"){
            fatalError("Bad Key")
        }
        return value
    }
}
