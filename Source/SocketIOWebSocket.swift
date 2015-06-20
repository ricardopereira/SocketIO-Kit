//
//  SocketIOWebSocket.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation
import SwiftWebSocket

private enum WSScheme: String {
    case WS = "ws"
    case WSS = "wss"
}

class SocketIOWebSocket: SocketIOTransport {

    private var ws: WebSocket!
    private let defaultPort = 80
    private var pingTimer: NSTimer?
    private var pongsMissed = 0
    private var pongsMaxRetries = 0
    
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
        
        if let scheme = hostUrl.scheme, host = hostUrl.host {
            // Establish connection
            if scheme.lowercaseString == "http" {
                // Standard
                createWS(.WS, host, port, handshake)
            }
            else {
                // TLS
                createWS(.WSS, host, port, handshake)
            }
        }
    }
    
    final override func close() {
        if isOpen {
            ws.close()
            ws = nil
        }
    }

    final override var isOpen: Bool {
        return ws != nil
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
        ws.send(packet)
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
        ws.send(packet)
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
        ws.send(packet)
    }
    
    final override func send(event: String, withObject object: SocketIOObject) {
        send(event, withDictionary: object.asDictionary)
    }
    
    private func createWS(scheme: WSScheme, _ host: String, _ port: Int, _ handshake: SocketIOHandshake) {
        if let url = NSURL(scheme: scheme.rawValue, host: "\(host):\(port)", path: "/socket.io/?transport=websocket&sid=\(handshake.sid)"), urlStr = url.absoluteString {
            ws = WebSocket(url: urlStr)
            setupWS(handshake)
        }
    }
    
    private func setupWS(handshake: SocketIOHandshake) {
        ws.event.open = {
            // Complete upgrade to WebSocket
            let confirmation = SocketIOPacket.encode(.Upgrade, withKey: .Event)
            self.ws.send(confirmation)
            // ... then server flushes and closes old transport and switches to new one
            
            if self.hasNamespace {
                let connectToNamespace = SocketIOPacket.encode(.Message, withKey: .Connect, andNamespace: self.delegate.options.namespace)
                self.ws.send(connectToNamespace)
                
                // Connect:
                //40/gallery
            }
        }
        
        ws.event.close = { code, reason, clean in
            #if DEBUG
                println("--- \(SocketIOName): WebSocket")
                println("closed")
            #endif
            self.pingTimer?.invalidate()
            self.delegate.didReceiveMessage(SocketIOEvent.Disconnected.description, withString: reason)
        }
        
        ws.event.error = { error in
            #if DEBUG
                println("--- \(SocketIOName): WebSocket")
                println("error: \(error)")
            #endif
            self.pingTimer?.invalidate()
            self.delegate.failure(.TransportError, withError: SocketIOError(error: error))
        }
        
        ws.event.message = { message in
            if let text = message as? String {
                #if DEBUG
                    println("--- \(SocketIOName): WebSocket")
                    println("received message> \(text)")
                #endif
                
                let (valid, hasNamespace, id, key, data) = SocketIOPacket.decode(text, withNamespace: self.nsp)
                
                if valid {
                    switch (id, key) {
                    case (PacketTypeID.Message, PacketTypeKey.Connect):
                        if hasNamespace {
                            #if DEBUG
                                println("--- \(SocketIOName): WebSocket Packet decoded")
                                println("connected on \(self.nsp)")
                            #endif
                            self.delegate.didReceiveMessage(SocketIOEvent.ConnectedNamespace.description, withString: self.nsp)
                        }
                        else {
                            #if DEBUG
                                println("--- \(SocketIOName): WebSocket Packet decoded")
                                println("connected")
                            #endif
                            self.delegate.didReceiveMessage(SocketIOEvent.Connected.description, withString: "")
                        }
                    case (PacketTypeID.Message, PacketTypeKey.Event):
                        // Event data
                        if data.count == 2, let eventName = data[0] as? String {
                            
                            //String or NSDictionary
                            if let dict = data[1] as? NSDictionary {
                                self.delegate.didReceiveMessage(eventName, withDictionary: dict)
                            }
                            if let list = data[1] as? NSArray {
                                self.delegate.didReceiveMessage(eventName, withList: list)
                            }
                            else if let value = data[1] as? String {
                                self.delegate.didReceiveMessage(eventName, withString: value)
                            }
                        }
                    case (PacketTypeID.Pong, _):
                        #if DEBUG
                            println("--- \(SocketIOName): WebSocket")
                            println("Pong")
                        #endif
                        // Handle pong
                        self.pongsMissed = 0
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
        
        pongsMaxRetries = handshake.pingTimeout / handshake.pingInterval
        pingTimer?.invalidate()
        //Start ping timer
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            if let weakSelf = self {
                weakSelf.pingTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(handshake.pingInterval), target: weakSelf, selector: Selector("sendPing"), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc private func sendPing() {
        if pongsMissed > pongsMaxRetries {
            // Server is not responding
            ws.close(code: 1000, reason: "ping timeout")
            return
        }
        pongsMissed++
        ws.send(PacketTypeID.Ping.value)
        #if DEBUG
            println("--- \(SocketIOName): WebSocket")
            println("Ping")
        #endif
    }
    
}
