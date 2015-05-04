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
                
                // Data
                let remaining = NSMakeRange(match.range.length, count(value) - match.range.length)
                let data = (value as NSString).substringWithRange(remaining)
                
                if !data.isEmpty, let jsonData = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    // Parse JSON
                    var err: NSError?
                    let parsed: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableLeaves, error: &err)
                    
                    if let parsedArray = parsed as? NSArray {
                        println(parsedArray[1])
                        
                        if let parsedDict = parsedArray[1] as? NSDictionary {
                            
                            println(parsedDict["name"])
                        }
                    }
                }

                // Result: ID and Key
                if let firstDigit = (value as NSString).substringToIndex(1).toInt(), let packetID = PacketTypeID(rawValue: firstDigit),
                    let secondDigit = (value as NSString).substringWithRange(NSMakeRange(1, 1)).toInt(), let packetKey = PacketTypeKey(rawValue: secondDigit)
                {
                    return (true, packetID, packetKey)
                }
            }
        }
        return (false, PacketTypeID.Close, PacketTypeKey.Error)
    }
    
}
