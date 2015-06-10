//
//  SocketIOTransportDelegate.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

internal extension NSURL {
    
    func hasTrailingSlash() -> Bool {
        return self.absoluteString.hasSuffix("/")
    }
    
    func URLByAppendingTrailingSlash() -> NSURL {
        if !self.hasTrailingSlash(), let url = NSURL(string: self.absoluteString + "/") {
            return url
        }
        else {
            return self
        }
    }
    
    func URLByDeletingTrailingSlash() -> NSURL {
        if self.hasTrailingSlash(), let url = NSURL(string: self.absoluteString.substringToIndex(self.absoluteString.endIndex.predecessor())) {
            return url
        }
        else {
            return self
        }
    }
    
    var relativeURL: NSURL? {
        if let port = self.port {
            return NSURL(string: "\(self.scheme)://\(self.host!):\(port)")
        }
        else {
            return NSURL(string: "\(self.scheme)://\(self.host!)")
        }
    }
    
}
