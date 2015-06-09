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
        if let urlAsString = self.absoluteString {
            return urlAsString.hasSuffix("/")
        }
        else {
            return false
        }
    }
    
    func URLByAppendingTrailingSlash() -> NSURL {
        if !self.hasTrailingSlash(), let urlAsString = self.absoluteString, let url = NSURL(string: urlAsString + "/") {
            return url
        }
        else {
            return self
        }
    }
    
    func URLByDeletingTrailingSlash() -> NSURL {
        if self.hasTrailingSlash(), let urlAsString = self.absoluteString, let url = NSURL(string: urlAsString.substringToIndex(urlAsString.endIndex.predecessor())) {
            return url
        }
        else {
            return self
        }
    }
    
    var relativeURL: NSURL? {
        if let port = self.port {
            return NSURL(string: "\(self.scheme!)://\(self.host!):\(port)")
        }
        else {
            return NSURL(string: "\(self.scheme!)://\(self.host!)")
        }
    }
    
}
