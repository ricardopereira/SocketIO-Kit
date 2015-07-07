//
//  SocketIOTransportDelegate.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

/**
Socket.io transport delegate.
*/
public protocol SocketIOTransportDelegate {
    
    /// Connection options.
    var options: SocketIOOptions { get }
    
    /**
    Tells the delegate that the transport suffer from a problem.
    
    :param: event System event.
    :param: error Socket.io error.
    */
    func failure(event: SocketIOEvent, withError error: SocketIOError)
    
    /**
    Tells the delegate that the transport did receive a text message.
    
    :param: event Event name.
    :param: message Text message.
    */
    func didReceiveMessage(event: String, withString message: String)
    
    /**
    Tells the delegate that the transport did receive a list of items.
    
    :param: event Event name.
    :param: list List of items.
    */
    func didReceiveMessage(event: String, withList list: NSArray)
    
    /**
    Tells the delegate that the transport did receive a dictionary.
    
    :param: event Event name.
    :param: dict Data dictionary.
    */
    func didReceiveMessage(event: String, withDictionary dict: NSDictionary)
    
}
