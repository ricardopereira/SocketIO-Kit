//
//  SocketIOHandshake.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

struct SocketIOHandshake {
    
    let sid: String
    let transport: [String]
    let pingInterval: Int
    let pingTimeout: Int
    
    init(sid: String, transport: [String], pingInterval: Int, pingTimeout: Int) {
        self.sid = sid
        self.transport = transport
        self.pingInterval = pingInterval
        self.pingTimeout = pingTimeout
    }
    
}