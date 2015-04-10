//
//  SocketIOConnection.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

class SocketIOConnection: SocketIOEventHandler, SocketIOEmitter {
    
    private let transport: SocketIOTransport
    
    init(transport: SocketIOTransport) {
        // Connection transport
        self.transport = transport
        // Designated
        super.init()
    }
    
    func emit(event: String, withMessage message: String) {
        performEvent(event, withMessage: message)
        performGlobalEvents(message)
    }
    
}
