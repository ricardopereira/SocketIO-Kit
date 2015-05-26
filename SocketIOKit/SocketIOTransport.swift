//
//  SocketIOTransport.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

class SocketIOTransport {
    
    internal let delegate: SocketIOTransportDelegate
    
    required init(delegate: SocketIOTransportDelegate) {
        self.delegate = delegate;
    }
    
    var isOpen: Bool { return false }

    func open(hostUrl: NSURL, withHandshake handshake: SocketIOHandshake) {}
    func close() {}
    func send(event: String, withString message: String) {}
    func send(event: String, withList list: NSArray) {}
    func send(event: String, withDictionary dict: NSDictionary) {}
    func send(event: String, withObject object: SocketIOObject) {}

}