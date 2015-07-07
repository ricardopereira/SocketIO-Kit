//
//  SocketIOError.swift
//  Smartime
//
//  Created by Ricardo Pereira on 03/05/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

/**
Socket.io error.
*/
public class SocketIOError: Printable {
    
    /// Error message.
    public let message: String
    
    /// More information about the error.
    public let info: [String]
    
    /**
    Creates an Error instance.
    
    :param: message Error message.
    :param: info More information.
    */
    public init(message: String, withInfo info: [String]) {
        self.message = message
        self.info = info
    }
    
    /**
    Creates an Error instance.
    
    :param: error Error information from NSError
    */
    public convenience init(error: NSError) {
        self.init(message: error.localizedDescription, withInfo: [""])
    }
    
    /// Printable text.
    public var description: String {
        return message + ": " + info.description
    }
    
}