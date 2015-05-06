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

class SocketIOConnection: SocketIOEventHandler, SocketIOEmitter, SocketIOTransportDelegate {
    
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
    
    func open(hostUrl: NSURL) {
        // GET request for Handshake
        //  - Indicate the transport: polling
        //  - b64: (XHR2 is not supported) signal the server that all binary data should be sent base64 encoded
        
        let url = NSURL(string: "socket.io/?transport=polling&b64=1", relativeToURL: hostUrl.URLByAppendingTrailingSlash())!;
        
        #if DEBUG
            println("\(SocketIO.name) - open: \(url)")
        #endif

        let request = NSURLRequest(URL: url)
        
        // Transport establishes a connection
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
        
        // Got error
        if let currentError = error {
            emit(.ConnectError, withError: SocketIOError(error: currentError))
            return
        }
        
        // Receive Payload: payload is used for transports which do not support framing
        //  - Format: <length1>:<packet1>
        //  - Length: length of the packet in characters
        //  - Packet: 0 for string data
        
        // Server responds with an open packet with JSON-encoded handshake data:
        //  - Session id
        //  - Possible transport upgrades
        //  - Ping interval
        //  - Ping timeout
        
        if let payload = NSString(data: data, encoding: NSUTF8StringEncoding) {
            #if DEBUG
                println("\(SocketIO.name) - data with UTF8 encoding: \(payload)")
            #endif
            
            // Interpret server response
            let jsonStr = SocketIOPayload.getStringPacket(payload)
            
            // Parse JSON info from response
            let (valid, handshake) = SocketIOHandshake.parse(jsonStr)
            
            if valid, let url = response?.URL, let hostUrl = url.relativeURL {
                // Connect
                transport.connect(hostUrl, withHandshake: handshake)
            }
            else {
                // Teste
                emit(.ConnectError, withError: SocketIOError(message: jsonStr, withInfo: []))
            }
            
            // Parse string data (when response status code: 200)
            //Example: 97:0{"sid":"G4uSss_etvVa6k-6AAAF","upgrades":["websocket"],"pingInterval":25000,"pingTimeout":60000}
            
            // Bad request
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
    
    func emit(event: SocketIOEvent, withError error: SocketIOError) {
        emit(event.description, withError: error)
    }
    
    func emit(event: String, withError error: SocketIOError) {
        performEvent(event, withError: error)
    }
    
    
    // MARK: SocketIOTransportDelegate
    
    func didReceiveMessage(event: String, withString message: String) {
        
    }
    
    func didReceiveMessage(event: String, withDictionary message: NSDictionary) {
        
    }
    
}
