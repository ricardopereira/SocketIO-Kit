//
//  SocketIOCallbackResult.swift
//  Smartime
//
//  Created by Ricardo Pereira on 07/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

enum SocketIOCallbackResult {
    
    case Success(status: Int)
    case Failed(message: String)
    
}