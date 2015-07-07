//
//  SocketIOObject.swift
//  Smartime
//
//  Created by Ricardo Pereira on 12/05/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

/**
Socket.io object protocol.
*/
public protocol SocketIOObject {
    
    /**
    Creates an instance  with data from a dictionary.
    
    :param: dict Data dictionary.
    */
    init(dict: NSDictionary)
    
    /// Retrieve a dictionary.
    var asDictionary: NSDictionary { get }
    
}