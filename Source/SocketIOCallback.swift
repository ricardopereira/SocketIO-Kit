//
//  SocketIOCallback.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

/**
Enum with valid arguments for event callback.

**Cases:**

 - Message
 - List
 - JSON Object
 - Failure
*/
public enum SocketIOArg<E: SocketIOError> {
    
    case Message(message: String)
    case List(list: NSArray)
    case JSON(json: NSDictionary)
    case Failure(E)
    
}

/// Type alias for an event callback.
public typealias SocketIOCallback = (SocketIOArg<SocketIOError>) -> ()
