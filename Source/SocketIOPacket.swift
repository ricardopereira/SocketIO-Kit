//
//  SocketIOPacket.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

enum PacketTypeID: Int {
    
    case Open
    case Close
    case Ping
    case Pong
    case Message
    
    var value: String {
        return String(self.rawValue)
    }
    
}

enum PacketTypeKey: Int {
    
    case Connect
    case Disconnect
    case Event
    case Ack
    case Error
    case BinaryEvent
    case BinaryAck
    
    var value: String {
        return String(self.rawValue)
    }
    
}