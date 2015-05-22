//
//  SocketIOJSON.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/05/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

protocol SocketIOJSON {
    
    typealias Model
    static func parse(json: String) -> (Bool, Model)

}

struct SocketIOJSONParser {
    
    private let json: LumaJSONObject
    
    init?(json: String) {
        if let json = LumaJSON.parse(json) {
            self.json = json
        }
        else {
            return nil
        }
    }
    
    subscript(key: String) -> AnyObject? {
        get {
            return json[key]?.value
        }
    }
    
}