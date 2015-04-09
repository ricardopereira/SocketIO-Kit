//
//  SocketIO.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

class SocketIO: SocketIOEventHandlerProtocol {
    
    lazy var connection = SocketIOConnection()
    
    convenience init?(url: String) {
        self.init(nsurl: NSURL(string: url))
    }
    
    convenience init?(nsurl: NSURL?) {
        self.init(nsurl: nsurl, withOptions: SocketIOOptions())
    }
    
    convenience init?(url: String, withOptions option: SocketIOOptions) {
        self.init(nsurl: NSURL(string: url), withOptions: option)
    }

    init?(nsurl: NSURL?, withOptions option: SocketIOOptions) {
        if nsurl == nil {
            return nil
        }
        else if !NSURLConnection.canHandleRequest(NSURLRequest(URL: nsurl!)) {
            return nil
        }
        else {
            println("URL is \(nsurl!.absoluteString)")
        }
        
    }
    
    func connect() {
        
    }
    
    func connect(customTransport: SocketIOTransport) {
        connection = SocketIOConnection(transport: customTransport)
    }
    
    
    //MARK: SocketIOEventHandlerProtocol
    
    func on(event: String, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        return connection.on(event, withCallback: callback)
    }
    
    func onAny(callback: SocketIOCallback) -> SocketIOEventHandler {
        return connection.onAny(callback)
    }
    
    func off() -> SocketIOEventHandler {
        return connection.off()
    }
    
}
