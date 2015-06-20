//
//  SocketIOEvent.swift
//  Smartime
//
//  Created by Ricardo Pereira on 10/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

// System events
public enum SocketIOEvent: String, Printable {
    
    case Connected = "connected" //Called on a successful connection
    case ConnectedNamespace = "connected_namespace" //Called on a successful namespace connection
    case Disconnected = "disconnected" //Called on a disconnection
    case ConnectError = "connect_error" //Called on a connection error
    case TransportError = "transport_error" //Called on a transport error (WebSocket, ...)
    case ReconnectAttempt = "reconnect_attempt" //Attempt for reconnection
    case EmitError = "emit_error" //Sending errors
    
    public var description: String {
        return self.rawValue
    }
    
    static var system: [SocketIOEvent] {
        return [.Connected, .ConnectedNamespace, .Disconnected, .ReconnectAttempt, .EmitError]
    }
    
}