//
//  SocketIOPayload.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/05/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

class SocketIOPayload {
    
    static private func regEx() -> NSRegularExpression? {
        // Regular Expression: <length>:<packet>, added 0 for parse optimization
        //because packet as suffix 0 for string data
        return NSRegularExpression(pattern: "^[0-9]{2,}:0", options: .CaseInsensitive, error: nil)
    }
    
    static func isStringPacket(payload: NSString) -> Bool {
        if let regex = regEx() {
            let all = NSMakeRange(0, payload.length)
            // Check pattern
            let matchPattern = regex.rangeOfFirstMatchInString(payload as String, options: .ReportProgress, range: all)
            // Result
            return matchPattern.location != NSNotFound
        }
        return false
    }
    
    static func getStringPacket(payload: NSString) -> String {
        if let regex = regEx() {
            let all = NSMakeRange(0, payload.length)
            // Check pattern and get remaining part: packet
            if let match = regex.firstMatchInString(payload as String, options: .ReportProgress, range: all) {
                let packet = NSMakeRange(match.range.length, payload.length - match.range.length)
                // Result: JSON
                return payload.substringWithRange(packet)
            }
        }
        return ""
    }
    
}