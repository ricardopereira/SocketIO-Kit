//
//  SocketIOCallback.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

enum SocketIOArg<E: NSError> {
    
    case Message(message: String)
    case Error(E)
    case Binary(data: NSData)
    
}

enum SocketIOResult {
    
    case Success(status: Int)
    case Failed(message: String)
    
}

typealias SocketIOCallback = (SocketIOArg<NSError>) -> (SocketIOResult)