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
    case Upgrade
    case Noop
    
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
        // Regular Expression: <packet type>[<data>]
        return NSRegularExpression(pattern: "^[0-9][0-9]", options: .CaseInsensitive, error: nil)
    }
    
    static func encode(id: PacketTypeID, withKey key: PacketTypeKey) -> String {
        return id.value + key.value
    }
    
    static func encode(id: PacketTypeID, withKey key: PacketTypeKey, withEvent event: String, andMessage message: String) -> String {
        // TODO: When event is empty
        return id.value + key.value + "[\"" + event + "\",\"" + message + "\"]"
    }
    
    static func encode(id: PacketTypeID, withKey key: PacketTypeKey, withEvent event: String, andDictionary dict: NSDictionary) -> String {
        let array = [event, dict]
        
        if NSJSONSerialization.isValidJSONObject(array) == false {
            return id.value + key.value
        }
        
        let jsonData : NSArray -> NSData? = {
            NSJSONSerialization.dataWithJSONObject($0, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        }
        
        let jsonStr : NSData -> NSString? = {
            NSString(data: $0, encoding: NSUTF8StringEncoding)
        }
        
        let result : NSString -> String? = {
            $0 as String
        }
        
        return id.value + key.value + (array >>- jsonData >>- jsonStr >>- result ?? "")
    }
    
    static func decode(value: String) -> (Bool, PacketTypeID, PacketTypeKey, NSArray) {
        if let regex = regEx() {
            let all = NSMakeRange(0, count(value))
            
            // <packet type id>[<data>]
            // 4 message + 2 event
            
            //42["chat message","example"]
            //42["object message",{"id":1,"name":"Xpto"}]
            
            // Check pattern and get remaining part: message data
            if let match = regex.firstMatchInString(value, options: .ReportProgress, range: all) {
                
                // Data
                let remaining = NSMakeRange(match.range.length, count(value) - match.range.length)
                // Ex: ["object message",{"id":1,"name":"Xpto"}]
                let remainingData = (value as NSString).substringWithRange(remaining)
                
                var data = []
                
                if !remainingData.isEmpty, let jsonData = remainingData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    // Parse JSON
                    var err: NSError?
                    let parsed: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableLeaves, error: &err)
                    
                    if let parsedArray = parsed as? NSArray {
                        data = parsedArray
                    }
                }

                // Result: ID and Key
                if let firstDigit = (value as NSString).substringToIndex(1).toInt(), let packetID = PacketTypeID(rawValue: firstDigit),
                    let secondDigit = (value as NSString).substringWithRange(NSMakeRange(1, 1)).toInt(), let packetKey = PacketTypeKey(rawValue: secondDigit)
                {
                    return (true, packetID, packetKey, data)
                }
            }
        }
        return (false, PacketTypeID.Close, PacketTypeKey.Error, [])
    }
    
}
