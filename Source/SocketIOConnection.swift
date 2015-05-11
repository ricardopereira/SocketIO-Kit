//
//  SocketIOConnection.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

class SocketIOConnection: SocketIOReceiver, SocketIOEmitter {
    
    private let requester: SocketIORequester
    private let eventHandler: SocketIOEventHandler
    private let transport: SocketIOTransport
    private let transportDelegate: TransportDelegate
    
    convenience init(transport: SocketIOTransport.Type) {
        self.init(requester: SessionRequest(), transport: transport)
    }
    
    init(requester: SocketIORequester, transport: SocketIOTransport.Type) {
        // Connection transport
        self.requester = requester
        self.eventHandler = SocketIOEventHandler()
        self.transportDelegate = TransportDelegate(eventHandler: eventHandler)
        self.transport = transport(delegate: transportDelegate)
    }
    
    func open(hostUrl: NSURL) {
        // GET request for Handshake
        //  - Indicate the transport: polling
        //  - b64: (XHR2 is not supported) signal the server that all binary data should be sent base64 encoded
        
        if transport.isOpen {
            #if DEBUG
                println("--- \(SocketIOName): Connection")
                println("connection is already open")
            #endif
            return
        }
        
        let url = NSURL(string: "socket.io/?transport=polling&b64=1", relativeToURL: hostUrl.URLByAppendingTrailingSlash())!;
        
        #if DEBUG
            println("--- \(SocketIOName): Connection")
            println("open: \(url)")
        #endif

        let request = NSURLRequest(URL: url)
        
        // Transport establishes a connection
        requester.sendRequest(request, completion: requestCompletion)
    }
    
    func close() {
        transport.close()
    }
    
    private func requestCompletion(data: NSData!, response: NSURLResponse?, error: NSError?) {
        #if DEBUG
            println("--- \(SocketIOName): Request")
            println("data: \(data)")
            println("response: \(response)")
            println("error: \(error)")
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
                println("--- \(SocketIOName): Response")
                println("data with UTF8 encoding: \(payload)")
            #endif
            
            // Interpret server response
            let jsonStr = SocketIOPayload.getStringPacket(payload)
            
            // Parse JSON info from response
            let (valid, handshake) = SocketIOHandshake.parse(jsonStr)
            
            if valid, let url = response?.URL, let hostUrl = url.relativeURL {
                // Connect
                transport.open(hostUrl, withHandshake: handshake)
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
        // Check system events
        for systemEvent in SocketIOEvent.system {
            if event == systemEvent.description {
                return
            }
        }
        // Call internal defined events
        eventHandler.performEvent(event, withMessage: message)
        eventHandler.performGlobalEvents(message)
        // Send message
        transport.send(event, withString: message)
    }
    
    final func emit(event: SocketIOEvent, withError error: SocketIOError) {
        emit(event.description, withError: error)
    }
    
    final func emit(event: String, withError error: SocketIOError) {
        // Check system events
        for systemEvent in SocketIOEvent.system {
            if event == systemEvent.description {
                return
            }
        }
        eventHandler.performEvent(event, withError: error)
        
        // ToDo - Send message
        
    }
    
    
    // MARK: SocketIOReceiver
    
    final func on(event: SocketIOEvent, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        return eventHandler.on(event, withCallback: callback)
    }
    
    final func on(event: String, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        return eventHandler.on(event, withCallback: callback)
    }
    
    final func onAny(callback: SocketIOCallback) -> SocketIOEventHandler {
        return eventHandler.onAny(callback)
    }
    
    final func off() -> SocketIOEventHandler {
        return eventHandler.off()
    }
    
}


// MARK: Private Classes

private class SessionRequest: SocketIORequester {
    
    // Request session
    private let session: NSURLSession
    // Handling a lot of requests at once
    private var requestsQueue = NSOperationQueue()
    
    init() {
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration(), delegate: nil, delegateQueue: self.requestsQueue)
    }
    
    final func sendRequest(request: NSURLRequest, completion: RequestCompletionHandler) {
        // Do request
        session.dataTaskWithRequest(request, completionHandler: completion).resume()
    }
    
}

private class TransportDelegate: SocketIOTransportDelegate {
    
    private let events: SocketIOEventHandler
    
    init(eventHandler: SocketIOEventHandler) {
        self.events = eventHandler
    }
    
    final func didReceiveMessage(event: String, withString message: String) {
        events.performEvent(event, withMessage: message)
    }
    
    final func didReceiveMessage(event: String, withDictionary message: NSDictionary) {
        events.performEvent(event, withJSON: message)
    }
    
}
