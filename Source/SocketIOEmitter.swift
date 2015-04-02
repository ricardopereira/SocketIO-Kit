//
//  SocketIOEmitter.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

protocol SocketIOEmitterProtocol {
    
    func on(event: String, withCallback callback: SocketIOCallback) -> SocketIOEmitter;
    
}

class SocketIOEmitter: SocketIOEmitterProtocol {
    
    func on(event: String, withCallback callback: SocketIOCallback) -> SocketIOEmitter {
        
        return self
    }
    
}
