//
//  SocketIOTransportDelegate.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

protocol SocketIOTransportDelegate {
    
    func failure(event: SocketIOEvent, error: SocketIOError)
    func didReceiveMessage(event: String, withString message: String)
    func didReceiveMessage(event: String, withList list: NSArray)
    func didReceiveMessage(event: String, withDictionary dict: NSDictionary)
    
}
