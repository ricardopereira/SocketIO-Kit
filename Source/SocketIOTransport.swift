//
//  SocketIOTransport.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

/**
Socket.io base transport.
*/
public class SocketIOTransport: NSObject {
    
    /// Transport delegate.
    let delegate: SocketIOTransportDelegate
    
    /**
    Creates a Socket.io transport.
    **Abstract class**
    
    :param: delegate Transport delegate.
    */
    public required init(delegate: SocketIOTransportDelegate) {
        self.delegate = delegate;
    }
    
    /// Flag to verify if the connection is open.
    var isOpen: Bool { return false }


    /**
    Open a connection with the host.
    
    :param: hostUrl Server URL.
    :param: handshake Handshake data.
    */
    func open(hostUrl: NSURL, withHandshake handshake: SocketIOHandshake) {}

    /**
    Close the current connection.
    */
    func close() {}
    
    /**
    Send a message to the current host.
    
    :param: event Event name.
    :param: message Text message.
    */
    func send(event: String, withString message: String) {}
    
    /**
    Send a message to the current host.
    
    :param: event Event name.
    :param: list List of items.
    */
    func send(event: String, withList list: NSArray) {}
    
    /**
    Send a message to the current host.
    
    :param: event Event name.
    :param: dict Data from dictionary.
    */
    func send(event: String, withDictionary dict: NSDictionary) {}
    
    /**
    Send a message to the current host.
    
    :param: event Event name.
    :param: object Socket.io Object.
    */
    func send(event: String, withObject object: SocketIOObject) {}

}
