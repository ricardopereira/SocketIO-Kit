//
//  SocketIOJSONHandshake.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/05/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

class SocketIOJSONHandshake: SocketIOJSON {
    
    static func parse(json: String) -> (Bool, SocketIOHandshake) {
        // Parse JSON
        if let parsed = SocketIOJSONParser(json: json),
            let sid = parsed["sid"] as? String,
            let transports = parsed["upgrades"] as? [String],
            let pingInterval = parsed["pingInterval"] as? Int,
            let pingTimeout = parsed["pingTimeout"] as? Int
        {
            // Valid
            return (true, SocketIOHandshake(sid: sid, transport: transports, pingInterval: pingInterval, pingTimeout: pingTimeout))
        }
        // Invalid
        return (false, SocketIOHandshake(sid: "", transport: [""], pingInterval: 0, pingTimeout: 0))
    }
    
}