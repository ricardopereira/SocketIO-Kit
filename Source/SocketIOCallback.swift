//
//  SocketIOCallback.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

enum SocketIOArg<E: SocketIOError> {
    
    case Message(message: String)
    case JSON(json: NSDictionary)
    case Failure(E)
    case Binary(data: NSData)
    
}

typealias SocketIOCallback = (SocketIOArg<SocketIOError>) -> ()