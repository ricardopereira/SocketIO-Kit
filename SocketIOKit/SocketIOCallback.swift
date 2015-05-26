//
//  SocketIOCallback.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

public enum SocketIOArg<E: SocketIOError> {
    
    case Message(message: String)
    case List(list: NSArray)
    case JSON(json: NSDictionary)
    case Failure(E)
    
}

public typealias SocketIOCallback = (SocketIOArg<SocketIOError>) -> ()