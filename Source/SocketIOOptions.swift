//
//  SocketIOOptions.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

/**
Socket.io client options.
*/
public class SocketIOOptions {
    
    public var namespace: String = ""
    
    public init() {
        
    }
    
    public func namespace(aNamespace: String?) -> SocketIOOptions {
        namespace = aNamespace ?? ""
        return self
    }

}
