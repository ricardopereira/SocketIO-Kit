//
//  FakeHTTPRequest.swift
//  SocketIOKit
//
//  Created by Ricardo Pereira on 26/05/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import SocketIOKit

public class FakeHTTPRequest: SocketIORequester {

    public final func sendRequest(request: NSURLRequest, completion: RequestCompletionHandler) {
        // Check request
        
        // Do request
        completion(nil, nil, nil)
    }
    
}