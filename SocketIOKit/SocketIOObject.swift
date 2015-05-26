//
//  SocketIOObject.swift
//  Smartime
//
//  Created by Ricardo Pereira on 12/05/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

public protocol SocketIOObject {
    
    init(dict: NSDictionary)
    var asDictionary: NSDictionary { get }
    
}