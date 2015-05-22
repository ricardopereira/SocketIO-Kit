//
//  SocketIOError.swift
//  Smartime
//
//  Created by Ricardo Pereira on 03/05/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

public class SocketIOError: Printable {
    
    let message: String
    let info: [String]
    
    init(message: String, withInfo info: [String]) {
        self.message = message
        self.info = info
    }
    
    convenience init(error: NSError) {
        self.init(message: error.localizedDescription, withInfo: [""])
    }
    
    public var description: String {
        return message + ": " + info.description
    }
    
}