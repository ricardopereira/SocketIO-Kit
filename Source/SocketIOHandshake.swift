//
//  SocketIOHandshake.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

struct SocketIOHandshake {
    
    static let defaultPingInterval = 25
    static let defaultPingTimeout = 60
    
    let sid: String
    let transport: [String]
    let pingInterval: Int
    let pingTimeout: Int

}