//
//  SocketIONamespace.swift
//  Smartime
//
//  Created by Ricardo Pereira on 17/05/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

class SocketIONamespace {
    
    static private func regEx() -> NSRegularExpression? {
        return NSRegularExpression(pattern: "^/([a-z][a-z0-9]+)", options: .CaseInsensitive, error: nil)
    }
    
    static func isValid(nsp: String) -> Bool {
        if nsp.isEmpty {
            return false
        }
        
        if let regex = regEx() {
            let all = NSMakeRange(0, count(nsp))
            
            if let match = regex.firstMatchInString(nsp, options: .ReportProgress, range: all) {
                let data = (nsp as NSString).substringWithRange(match.range)
                
                if data == nsp {
                    return true
                }
            }
        }
        return false
    }
    
}