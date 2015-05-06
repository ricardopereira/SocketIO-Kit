//
//  SocketIOTransport.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

class SocketIOTransport {
    
    let delegate: SocketIOTransportDelegate
    
    required init(delegate: SocketIOTransportDelegate) {
        self.delegate = delegate;
    }
    
    func connect(hostUrl: NSURL, withHandshake handshake: SocketIOHandshake) {
        
    }
    
}
