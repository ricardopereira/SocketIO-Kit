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

class SocketIOPacket {
    
    static private func regEx() -> NSRegularExpression? {
        // Regular Expression: <length>:<packet>, added 0 for parse optimization
        //because packet as suffix 0 for string data
        return NSRegularExpression(pattern: "^[0-9][0-9]", options: .CaseInsensitive, error: nil)
    }
    
    static func decode(value: String) -> (Bool, PacketTypeID, PacketTypeKey) {
        if let regex = regEx() {
            let all = NSMakeRange(0, count(value))
            // Check pattern and get remaining part: packet type
            if let match = regex.firstMatchInString(value, options: .ReportProgress, range: all) {
                // Result: ID and Key
                let firstDigit = NSMakeRange(0, 1)
                let secondDigit = NSMakeRange(1, 1)
                
                let nsstr = value as NSString
                
                if let firstDigit = nsstr.substringWithRange(firstDigit).toInt(), let packetID = PacketTypeID(rawValue: firstDigit),
                    let secondDigit = nsstr.substringWithRange(secondDigit).toInt(), let packetKey = PacketTypeKey(rawValue: secondDigit)
                {
                    return (true, packetID, packetKey)
                }
            }
        }
        return (false, PacketTypeID.Close, PacketTypeKey.Error)
    }
    
}
