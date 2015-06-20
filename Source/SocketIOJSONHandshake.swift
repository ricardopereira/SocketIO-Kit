//
//  SocketIOJSONHandshake.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/05/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

extension SocketIOHandshake: SocketIOJSON {
        
    static func parse(json: String) -> (Bool, SocketIOHandshake) {
        // Parse JSON
        if let parsed = SocketIOJSONParser(json: json),
            let sid = parsed["sid"] as? String,
            let transports = parsed["upgrades"] as? [String],
            var pingInterval = parsed["pingInterval"] as? Int,
            var pingTimeout = parsed["pingTimeout"] as? Int
        {
            pingInterval = pingInterval / 1000
            pingTimeout = pingTimeout / 1000
            // Valid
            return (true, SocketIOHandshake(sid: sid, transport: transports, pingInterval: pingInterval, pingTimeout: pingTimeout))
        }
        // Invalid
        return (false, SocketIOHandshake(sid: "", transport: [""], pingInterval: defaultPingInterval, pingTimeout: defaultPingTimeout))
    }
    
}