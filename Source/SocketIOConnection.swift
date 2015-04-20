//
//  SocketIOConnection.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

private class SessionRequest: SocketIORequester {
    
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
        self.init(requester: SessionRequest(), transport: transport)
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
            println("\(SocketIO.name) - open: \(url)")
        #endif

        let request = NSURLRequest(URL: url)
        
        requester.sendRequest(request, completion: requestCompletion)
    }
    
    func close() {
        
    }
    
    private func requestCompletion(data: NSData!, response: NSURLResponse?, error: NSError?) {
        #if DEBUG
            println("\(SocketIO.name) - data: \(data)")
            println("\(SocketIO.name) - response: \(response)")
            println("\(SocketIO.name) - error: \(error)")
        #endif
        
        // Catched error
        if let currentError = error {
            emit(.ConnectError, withError: currentError)
            return
        }
        
        if let dataStr = NSString(data: data, encoding: NSUTF8StringEncoding) {
            #if DEBUG
                println("\(SocketIO.name) - data with UTF8 encoding: \(dataStr)")
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
    }
    
    
    // MARK: SocketIOEmitter

    final func emit(event: SocketIOEvent, withMessage message: String) {
        emit(event.description, withMessage: message)
    }
    
    final func emit(event: String, withMessage message: String) {
        performEvent(event, withMessage: message)
        performGlobalEvents(message)
    }
    
    func emit(event: SocketIOEvent, withError error: NSError) {
        emit(event.description, withError: error)
    }
    
    func emit(event: String, withError error: NSError) {
        performEvent(event, withError: error)
    }
    
}
