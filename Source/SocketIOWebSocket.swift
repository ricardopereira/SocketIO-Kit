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
    
    func connect(hostUrl: NSURL, withHandshake handshake: SocketIOHandshake) {
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
    
    func websocketDidConnect(socket: WebSocket) {
        println("Connect websocket")
        
        // Complete upgrade to WebSocket
        // 5 upgrade + 2 event
        socket.writeString("52")
        
        // Server flushes and closes old transport and switches to new
        
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        println("Disconnet websocket: \(error)")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        println("Received: \(data)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        println("Message: \(text)")
        
        let (valid, id, key) = SocketIOPacket.decode(text)
        
        if valid {
            switch (id, key) {
            case (PacketTypeID.Message, PacketTypeKey.Connect):
                println("done")
            default:
                println("none")
            }
        }
        
        // <packet type id>[<data>]
        // 4 message + 2 event
        //Message: 42["chat message","lkjlkj"]
        
        //There's two distinct types of encodings
        // - packet
        // - payload
    }
    
}
