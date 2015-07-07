//
//  SocketIORequester.swift
//  Smartime
//
//  Created by Ricardo Pereira on 11/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

/**
Type alias for request completion handler.
*/
public typealias RequestCompletionHandler = (NSData!, NSURLResponse?, NSError?) -> Void

/**
Protocol for custom requests.
*/
public protocol SocketIORequester {
    
    /**
    Send a remote request.
    
    :param: request Current request.
    :param: completion Request callback.
    */
    func sendRequest(request: NSURLRequest, completion: RequestCompletionHandler)
    
}