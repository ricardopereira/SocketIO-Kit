//
//  SocketIOEvent.swift
//  Smartime
//
//  Created by Ricardo Pereira on 10/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

// System events
enum SocketIOEvent: String, Printable {
    
    case Connect = "connect"
    case Disconnect = "disconnect"
    
    var description: String {
        return self.rawValue
    }
    
}