//
//  SocketIOEmitter.swift
//  Smartime
//
//  Created by Ricardo Pereira on 10/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

protocol SocketIOEmitter {
    
    func emit(event: SocketIOEvent, withMessage message: String)
    func emit(event: String, withMessage message: String)
    func emit(event: SocketIOEvent, withList list: NSArray)
    func emit(event: String, withList list: NSArray)
    func emit(event: SocketIOEvent, withDictionary dict: NSDictionary)
    func emit(event: String, withDictionary dict: NSDictionary)
    func emit(event: SocketIOEvent, withObject object: SocketIOObject)
    func emit(event: String, withObject object: SocketIOObject)
    
}