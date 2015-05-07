//
//  SocketIOWebSocket.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

class SocketIOWebSocket: SocketIOTransport, WebSocketDelegate {
    
    var socket: WebSocket?
    
    final override func connect(hostUrl: NSURL, withHandshake handshake: SocketIOHandshake) {
        // WebSocket
        if let scheme = hostUrl.scheme, let host = hostUrl.host, let port = hostUrl.port {
            // Establish connection
            if scheme.lowercaseString == "http" {
                // Standard
                socket = WebSocket(url: NSURL(scheme: "ws", host: "\(host):\(port)", path: "/socket.io/?transport=websocket&sid=\(handshake.sid)")!)
            }
            else {
                // TLS
                socket = WebSocket(url: NSURL(scheme: "wss", host: "\(host):\(port)", path: "/socket.io/?transport=websocket&sid=\(handshake.sid)")!)
            }
            
            socket?.delegate = self
            socket?.connect()
        }
    }
    
    
    // MARK: WebSocketDelegate
    
    final func websocketDidConnect(socket: WebSocket) {
        println("Connect websocket")
        
        // Complete upgrade to WebSocket
        // 5 upgrade + 2 event
        socket.writeString("52")
        
        // Server flushes and closes old transport and switches to new
        
    }
    
    final func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        println("Disconnet websocket: \(error)")
    }
    
    final func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        println("Received: \(data)")
    }
    
    final func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        println("Message: \(text)")
        
        let (valid, id, key, data) = SocketIOPacket.decode(text)
        
        if valid {
            switch (id, key) {
            case (PacketTypeID.Message, PacketTypeKey.Connect):
                println("Connected")
            case (PacketTypeID.Message, PacketTypeKey.Event):
                // Event data
                if data.count == 2, let eventName = data[0] as? String {
                    
                    //String or NSDictionary
                    if let dict = data[1] as? NSDictionary {
                        delegate.didReceiveMessage(eventName, withDictionary: dict)
                    }
                    else if let value = data[1] as? String {
                        delegate.didReceiveMessage(eventName, withString: value)
                    }
                }
            default:
                println("none")
            }
        }
                
        //There's two distinct types of encodings
        // - packet
        // - payload
    }
    
}
