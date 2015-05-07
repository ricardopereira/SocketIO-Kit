//
//  SocketIOReceiver.swift
//  Smartime
//
//  Created by Ricardo Pereira on 07/05/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

protocol SocketIOReceiver {
    
    func on(event: String, withCallback callback: SocketIOCallback) -> SocketIOEventHandler
    func on(event: SocketIOEvent, withCallback callback: SocketIOCallback) -> SocketIOEventHandler
    func onAny(callback: SocketIOCallback) -> SocketIOEventHandler
    func off() -> SocketIOEventHandler
    
}