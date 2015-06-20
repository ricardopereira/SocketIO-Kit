//
//  SocketIOPacket.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation
import Runes

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
    
    static private func regEx(namespace nsp: String) -> NSRegularExpression? {
        // Regular Expression: <packet type>/nsp,[<data>]
        return NSRegularExpression(pattern: "^[0-9][0-9]" + nsp, options: .CaseInsensitive, error: nil)
    }
    
    
    // MARK: Encode
    
    static func encode(id: PacketTypeID, withKey key: PacketTypeKey) -> String {
        return id.value + key.value
    }
    
    static func encode(id: PacketTypeID, withKey key: PacketTypeKey, andNamespace nsp: String) -> String {
        return id.value + key.value + nsp
    }
    
    static func encode(id: PacketTypeID, withKey key: PacketTypeKey, andEvent event: String, andMessage message: String) -> String {
        return encode(id, withKey: key, andNamespace: "", andEvent: event, andMessage: message)
    }
    
    static func encode(id: PacketTypeID, withKey key: PacketTypeKey, andNamespace nsp: String, andEvent event: String, andMessage message: String) -> String {
        if nsp.isEmpty {
            if event.isEmpty {
                return id.value + key.value
            }
            return id.value + key.value + "[\"" + event + "\",\"" + message + "\"]"
        }
        else {
            if event.isEmpty {
                return id.value + key.value + nsp + ","
            }
            return id.value + key.value + nsp + ",[\"" + event + "\",\"" + message + "\"]"
        }
    }
    
    static func encode(id: PacketTypeID, withKey key: PacketTypeKey, andEvent event: String, andList list: NSArray) -> (String, SocketIOError?) {
        return encode(id, withKey: key, andNamespace: "", andEvent: event, andList: list)
    }
    
    static func encode(id: PacketTypeID, withKey key: PacketTypeKey, andNamespace nsp: String, andEvent event: String, andList list: NSArray) -> (String, SocketIOError?) {
        let array = [event, list]
        
        if event.isEmpty || !NSJSONSerialization.isValidJSONObject(array) {
            return (id.value + key.value, SocketIOError(message: "Invalid JSON Object", withInfo: ["Event: \(event)"]))
        }
        
        let message = (array >>- SocketIOUtilities.arrayToJSON) ?? ""
        
        if nsp.isEmpty {
            return (id.value + key.value + message, nil)
        }
        else {
            return (id.value + key.value + nsp + "," + message, nil)
        }
    }
    
    static func encode(id: PacketTypeID, withKey key: PacketTypeKey, andEvent event: String, andDictionary dict: NSDictionary) -> (String, SocketIOError?) {
        return encode(id, withKey: key, andNamespace: "", andEvent: event, andDictionary: dict)
    }
    
    static func encode(id: PacketTypeID, withKey key: PacketTypeKey, andNamespace nsp: String, andEvent event: String, andDictionary dict: NSDictionary) -> (String, SocketIOError?) {
        let array = [event, dict]
        
        if event.isEmpty || !NSJSONSerialization.isValidJSONObject(array) {
            return (id.value + key.value, SocketIOError(message: "Invalid JSON Object", withInfo: ["Event: \(event)"]))
        }
        
        let message = (array >>- SocketIOUtilities.arrayToJSON) ?? ""
        
        if nsp.isEmpty {
            return (id.value + key.value + message, nil)
        }
        else {
            return (id.value + key.value + nsp + "," + message, nil)
        }
    }

    
    // MARK: Decode
    
    static func decode(value: String) -> (Bool, Bool, PacketTypeID, PacketTypeKey, NSArray) {
        // Just a number
        if let ID = value.toInt(), packetID = PacketTypeID(rawValue: ID) {
            return (true, false, packetID, PacketTypeKey.Event, [])
        }
        
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
                if let firstDigit = (value as NSString).substringToIndex(1).toInt(), packetID = PacketTypeID(rawValue: firstDigit),
                    secondDigit = (value as NSString).substringWithRange(NSMakeRange(1, 1)).toInt(), packetKey = PacketTypeKey(rawValue: secondDigit)
                {
                    return (true, false, packetID, packetKey, data)
                }
            }
        }
        return (false, false, PacketTypeID.Close, PacketTypeKey.Error, [])
    }
    
    static func decode(value: String, withNamespace nsp: String) -> (Bool, Bool, PacketTypeID, PacketTypeKey, NSArray) {
        if nsp.isEmpty {
            return decode(value)
        }
        
        // Just a number
        if let ID = value.toInt(), packetID = PacketTypeID(rawValue: ID) {
            return (true, false, packetID, PacketTypeKey.Event, [])
        }
        
        if let regex = regEx(namespace: nsp) {
            let all = NSMakeRange(0, count(value))
            
            //42/gallery,["chat message","message for gallery group"]
            
            // Check pattern and get remaining part: message data
            if let match = regex.firstMatchInString(value, options: .ReportProgress, range: all) {
                
                var data = []
                
                if match.range.length < count(value) {
                    let comma = 1
                    // Data
                    let remaining = NSMakeRange(match.range.length + comma, count(value) - match.range.length - comma)
                    // Ex: ["object message",{"id":1,"name":"Xpto"}]
                    let remainingData = (value as NSString).substringWithRange(remaining)
                    
                    if !remainingData.isEmpty, let jsonData = remainingData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                        // Parse JSON
                        var err: NSError?
                        let parsed: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableLeaves, error: &err)
                        
                        if let parsedArray = parsed as? NSArray {
                            data = parsedArray
                        }
                    }
                }
                
                // Result: ID and Key
                if let firstDigit = (value as NSString).substringToIndex(1).toInt(), packetID = PacketTypeID(rawValue: firstDigit),
                    secondDigit = (value as NSString).substringWithRange(NSMakeRange(1, 1)).toInt(), packetKey = PacketTypeKey(rawValue: secondDigit)
                {
                    return (true, true, packetID, packetKey, data)
                }
            }
            else {
                // Invalid namespace: try with empty nsp
                return decode(value)
            }
        }
        return (false, false, PacketTypeID.Close, PacketTypeKey.Error, [])
    }
    
}
