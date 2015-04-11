//
//  SocketIOConnection.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

private class GETRequest: SocketIORequester {
    
    // Request session
    private let session: NSURLSession
    // Handling a lot of requests at once
    private var requestsQueue = NSOperationQueue()
    
    init() {
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration(), delegate: nil, delegateQueue: self.requestsQueue)
    }
    
    func sendRequest(request: NSURLRequest, completion: RequestCompletionHandler) {
        // Do request
        session.dataTaskWithRequest(request, completionHandler: completion).resume()
    }
    
}

class SocketIOConnection: SocketIOEventHandler, SocketIOEmitter {
    
    private let requester: SocketIORequester
    private let transport: SocketIOTransport
    
    convenience init(transport: SocketIOTransport) {
        self.init(requester: GETRequest(), transport: transport)
    }
    
    init(requester: SocketIORequester, transport: SocketIOTransport) {
        // Connection transport
        self.requester = requester
        self.transport = transport
        // Designated
        super.init()
    }
    
    func open(serverUrl: NSURL) {
        // GET request for Handshake
        let url = NSURL(string: "socket.io/?transport=polling&b64=1", relativeToURL: serverUrl.URLByAppendingTrailingSlash())!;
        #if DEBUG
            println("Data: \(url)")
        #endif

        let request = NSURLRequest(URL: url)
        
        requester.sendRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            #if DEBUG
                println("Data: \(data)")
            #endif
            
            if let currentData = data, dataStr = NSString(data: currentData, encoding: NSUTF8StringEncoding) {
                #if DEBUG
                    println("Data UTF8: \(dataStr)")
                #endif
                
                // Parse string data
                //Example: 97:0{"sid":"G4uSss_etvVa6k-6AAAF","upgrades":["websocket"],"pingInterval":25000,"pingTimeout":60000} with response status code: 200
                
                let parsed = dataStr.componentsSeparatedByString(":0")
                
                if let jsonStr = parsed[1] as? String {
                    if let json = LumaJSON.parse(jsonStr) {
                        #if DEBUG
                            println("JSON: \(json)")
                        #endif
                        
                        if let sid = json["sid"] as? String {
                            println("SID: \(sid)")
                            
                            //transport.connect()
                            
                            //self.socket = WebSocket(url: NSURL(scheme: "ws", host: "localhost:8000", path: "/socket.io/?transport=websocket&sid=\(sid)")!)
                            //self.socket?.delegate = self
                            //self.socket?.connect()
                        }
                    }
                }
                
                //Error: {"code":3,"message":"Bad request"} with response status code: 400
            }
            
            #if DEBUG
                println("Response: \(response)")
                println("Error: \(error)")
            #endif
        }
    }
    
    func close() {
        
    }
    
    
    // MARK: SocketIOEmitter
    
    final func emit(event: String, withMessage message: String) {
        performEvent(event, withMessage: message)
        performGlobalEvents(message)
    }
    
}
