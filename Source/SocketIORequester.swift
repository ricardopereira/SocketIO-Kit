//
//  SocketIORequester.swift
//  Smartime
//
//  Created by Ricardo Pereira on 11/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

public typealias RequestCompletionHandler = (NSData!, NSURLResponse?, NSError?) -> Void

public protocol SocketIORequester {
    
    func sendRequest(request: NSURLRequest, completion: RequestCompletionHandler)
    
}