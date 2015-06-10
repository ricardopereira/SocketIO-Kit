//
//  SocketIOWebSocket.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

class SocketIOWebSocket: SocketIOTransport, WebSocketDelegate {
    
    private var socket: WebSocket!
    private let defaultPort = 80
    
    private var nsp: String {
        return delegate.options.namespace
    }
    
    private var hasNamespace: Bool {
        return !nsp.isEmpty
    }
        
    final override func open(hostUrl: NSURL, withHandshake handshake: SocketIOHandshake) {
        // WebSocket
        if isOpen {
            return
        }
        
        // Check current port
        let port: Int
        if let hostPort = hostUrl.port {
            port = hostPort.integerValue
        }
        else {
            port = defaultPort
        }
        
        if let host = hostUrl.host {
            // Establish connection
            if hostUrl.scheme.lowercaseString == "http" {
                // Standard
                socket = WebSocket(url: NSURL(scheme: "ws", host: "\(host):\(port)", path: "/socket.io/?transport=websocket&sid=\(handshake.sid)")!)
            }
            else {
                // TLS
                socket = WebSocket(url: NSURL(scheme: "wss", host: "\(host):\(port)", path: "/socket.io/?transport=websocket&sid=\(handshake.sid)")!)
            }
            
            socket.delegate = self
            socket.connect()
        }
    }
    
    final override func close() {
        if isOpen {
            socket.disconnect()
            socket = nil
        }
    }

    final override var isOpen: Bool {
        return socket != nil
    }
    
    final override func send(event: String, withString message: String) {
        if !isOpen {
            #if DEBUG
                println("--- \(SocketIOName): Send")
                println("Transport is closed")
            #endif
            return
        }
        
        let packet: String
        
        if hasNamespace {
            packet = SocketIOPacket.encode(.Message, withKey: .Event, andNamespace: nsp, andEvent: event, andMessage: message)
            
            // Example: namespace "/gallery"
            // Message:
            //  - 42/gallery,["event", {}]
        }
        else {
            packet = SocketIOPacket.encode(.Message, withKey: .Event, andEvent: event, andMessage: message)
        }
        
        #if DEBUG
            println("--- \(SocketIOName): WebSocket")
            println("sending> \(packet)")
        #endif
        socket.writeString(packet)
    }
    
    final override func send(event: String, withList list: NSArray) {
        if !isOpen {
            #if DEBUG
                println("--- \(SocketIOName): Send")
                println("Transport is closed")
            #endif
            return
        }
        
        let packet: String
        let error: SocketIOError?
        
        if hasNamespace {
            (packet, error) = SocketIOPacket.encode(.Message, withKey: .Event, andNamespace: nsp, andEvent: event, andList: list)
        }
        else {
            (packet, error) = SocketIOPacket.encode(.Message, withKey: .Event, andEvent: event, andList: list)
        }

        if let e = error {
            delegate.failure(.EmitError, withError: e)
            return
        }
        
        #if DEBUG
            println("--- \(SocketIOName): WebSocket")
            println("sending> \(packet)")
        #endif
        socket.writeString(packet)
    }
    
    final override func send(event: String, withDictionary dict: NSDictionary) {
        if !isOpen {
            #if DEBUG
                println("--- \(SocketIOName): Send")
                println("Transport is closed")
            #endif
            return
        }
        
        let packet: String
        let error: SocketIOError?
        
        if hasNamespace {
            (packet, error) = SocketIOPacket.encode(.Message, withKey: .Event, andNamespace: nsp, andEvent: event, andDictionary: dict)
        }
        else {
            (packet, error) = SocketIOPacket.encode(.Message, withKey: .Event, andEvent: event, andDictionary: dict)
        }
        
        if let e = error {
            delegate.failure(.EmitError, withError: e)
            return
        }
        
        #if DEBUG
            println("--- \(SocketIOName): WebSocket")
            println("sending> \(packet)")
        #endif
        socket.writeString(packet)
    }
    
    final override func send(event: String, withObject object: SocketIOObject) {
        send(event, withDictionary: object.asDictionary)
    }
    
    
    // MARK: WebSocketDelegate
    
    func websocketDidConnect(socket: WebSocket) {
        // Complete upgrade to WebSocket
        let confirmation = SocketIOPacket.encode(.Upgrade, withKey: .Event)
        socket.writeString(confirmation)
        // ... then server flushes and closes old transport and switches to new

        if hasNamespace {
            let connectToNamespace = SocketIOPacket.encode(.Message, withKey: .Connect, andNamespace: delegate.options.namespace)
            socket.writeString(connectToNamespace)
            
            // Connect:
            //40/gallery
        }
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        #if DEBUG
            println("--- \(SocketIOName): WebSocket")
            println("disconnected")
            println("error: \(error)")
        #endif
        close()
        if let disconnectError = error {
            delegate.failure(.Disconnected, withError: SocketIOError(error: disconnectError))
        }
        else {
            delegate.didReceiveMessage(SocketIOEvent.Disconnected.description, withString: "")
        }
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        // WebSocket requires that you put your Socket either into “string mode” or “binary mode”
        //  - SocketIO use "string mode"
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        #if DEBUG
            println("--- \(SocketIOName): WebSocket")
            println("received message> \(text)")
        #endif
        
        let (valid, id, key, data) = SocketIOPacket.decode(text, withNamespace: nsp)
        
        if valid {
            switch (id, key) {
            case (PacketTypeID.Message, PacketTypeKey.Connect):
                #if DEBUG
                    println("--- \(SocketIOName): WebSocket Packet decoded")
                    println("connected")
                #endif
                delegate.didReceiveMessage(SocketIOEvent.Connected.description, withString: "")
            case (PacketTypeID.Message, PacketTypeKey.Event):
                // Event data
                if data.count == 2, let eventName = data[0] as? String {
                    
                    //String or NSDictionary
                    if let dict = data[1] as? NSDictionary {
                        delegate.didReceiveMessage(eventName, withDictionary: dict)
                    }
                    if let list = data[1] as? NSArray {
                        delegate.didReceiveMessage(eventName, withList: list)
                    }
                    else if let value = data[1] as? String {
                        delegate.didReceiveMessage(eventName, withString: value)
                    }
                }
            default:
                #if DEBUG
                    println("--- \(SocketIOName): WebSocket Packet decoded")
                    println("not supported")
                #endif
            }
        }
                
        //There's two distinct types of encodings
        // - packet
        // - payload
        
        // engine:ws received "42["chat message","hello men"]"
        // decoded 2["chat message","hello men"] as {"type":2,"nsp":"/","data":["chat message","hello men"]}
        
        // encoding packet {"type":2,"data":["chat message","hello men"],"nsp":"/"}
        // encoded {"type":2,"data":["chat message","hello men"],"nsp":"/"} as 2["chat message","hello men"]
    }
    
}
