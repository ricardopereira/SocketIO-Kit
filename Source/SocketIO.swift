//
//  SocketIO.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

class SocketIO: SocketIOEmitterProtocol {
    
    lazy var connection = SocketIOConnection()
    
    init(url: String) {
        
    }
    
    init(url: NSURL) {
        
    }
    
    init(url: String, withOptions option: SocketIOOptions) {
        
    }

    init(url: NSURL, withOptions option: SocketIOOptions) {
        
    }
    
    func connect() {
        
    }
    
    
    //MARK: SocketIOEmitterProtocol
    
    func on(event: String, withCallback callback: SocketIOCallback) -> SocketIOEmitter {
        return connection.on(event, withCallback: callback)
    }
    
}
