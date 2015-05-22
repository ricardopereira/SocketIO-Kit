//
//  SocketIO.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

internal let SocketIOName = "SocketIO"

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

public class SocketIO<T: Printable>: SocketIOReceiver, SocketIOEmitter {
    
    private let url: NSURL
    private let options: SocketIOOptions
    private let connection: SocketIOConnection
    
    convenience public init(url: String) {
        if let url = NSURL(string: url) {
            self.init(nsurl: url)
        }
        else {
            assertionFailure("\(SocketIOName): Invalid URL")
            self.init(url: "")
        }
    }
    
    convenience public init(url: String, withOptions options: SocketIOOptions) {
        if let url = NSURL(string: url) {
            self.init(nsurl: url, withOptions: options, withRequest: SessionRequest(), withTransport: SocketIOWebSocket.self)
        }
        else {
            assertionFailure("\(SocketIOName): Invalid URL")
            self.init(url: "", withOptions: options)
        }
    }
    
    convenience public init(nsurl: NSURL) {
        self.init(nsurl: nsurl, withOptions: SocketIOOptions(), withRequest: SessionRequest(), withTransport: SocketIOWebSocket.self)
    }

    init(nsurl: NSURL, withOptions options: SocketIOOptions, withRequest request: SocketIORequester, withTransport transport: SocketIOTransport.Type) {
        url = nsurl
        self.options = options
        connection = SocketIOConnection(options: options, requester: request, transport: transport.self)
    }
    
    public final func connect() {
        connection.open(url)
    }
    
    public final func disconnect() {
        connection.close()
    }
    
    public final func reconnect() {
        connection.close()
        connection.open(url)
    }

    
    //MARK: SocketIOEmitter
    
    /**
    Sends a text message to the server.
    
    :param: event     Event name provided with SocketIOEvent.
    :param: message   Message to send.
    */
    public final func emit(event: SocketIOEvent, withMessage message: String) {
        emit(event.description, withMessage: message)
    }

    /**
    Sends a text message to the server.
    
    :param: event     Event name provided with generic type.
    :param: message   Message to send.
    */
    public final func emit(event: T, withMessage message: String) {
        emit(event.description, withMessage: message)
    }

    /**
    Sends a text message to the server.
    
    :param: event     Event name.
    :param: message   Message to send.
    */
    public final func emit(event: String, withMessage message: String) {
        connection.emit(event, withMessage: message)
    }

    /**
    Sends a list of items to the server.
    
    :param: event   Event name provided with SocketIOEvent.
    :param: list    List of type NSArray to send.
    */
    public final func emit(event: SocketIOEvent, withList list: NSArray) {
        emit(event.description, withList: list)
    }

    /**
    Sends a list of items to the server.
    
    :param: event   Event name provided with generic type.
    :param: list    List of type NSArray to send.
    */
    public final func emit(event: T, withList list: NSArray) {
        emit(event.description, withList: list)
    }
    
    /**
    Sends a list of items to the server.
    
    :param: event   Event name.
    :param: list    List of type NSArray to send.
    */
    public final func emit(event: String, withList list: NSArray) {
        connection.emit(event, withList: list)
    }
    
    /**
    Sends a dictionary (key-value) to the server.
    
    :param: event   Event name provided with SocketIOEvent.
    :param: dict    Key-value object of type NSDictionary to send.
    */
    public final func emit(event: SocketIOEvent, withDictionary dict: NSDictionary) {
        emit(event.description, withDictionary: dict)
    }

    /**
    Sends a dictionary (key-value) to the server.
    
    :param: event   Event name provided with generic type.
    :param: dict    Key-value object of type NSDictionary to send.
    */
    public final func emit(event: T, withDictionary dict: NSDictionary) {
        emit(event.description, withDictionary: dict)
    }

    /**
    Sends a dictionary (key-value) to the server.
    
    :param: event   Event name.
    :param: dict    Key-value object of type NSDictionary to send.
    */
    public final func emit(event: String, withDictionary dict: NSDictionary) {
        connection.emit(event, withDictionary: dict)
    }
    
    /**
    Sends a object to the server.
    
    :param: event   Event name provided with SocketIOEvent.
    :param: object  Object that comply SocketIOObject protocol.
    */
    public final func emit(event: SocketIOEvent, withObject object: SocketIOObject) {
        emit(event.description, withObject: object)
    }
    
    /**
    Sends a object to the server.
    
    :param: event   Event name provided with generic type.
    :param: object  Object that comply SocketIOObject protocol.
    */
    public final func emit(event: T, withObject object: SocketIOObject) {
        emit(event.description, withObject: object)
    }
    
    /**
    Sends a object to the server.
    
    :param: event   Event name provided.
    :param: object  Object that comply SocketIOObject protocol.
    */
    public final func emit(event: String, withObject object: SocketIOObject) {
        connection.emit(event, withObject: object)
    }

    
    
    //MARK: SocketIOReceiver
    
    public final func on(event: SocketIOEvent, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        return connection.on(event, withCallback: callback)
    }
    
    public final func on(event: T, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        return on(event.description, withCallback: callback)
    }
    
    public final func on(event: String, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        return connection.on(event, withCallback: callback)
    }
    
    public final func onAny(callback: SocketIOCallback) -> SocketIOEventHandler {
        return connection.onAny(callback)
    }
    
    public final func off() -> SocketIOEventHandler {
        return connection.off()
    }
    
}
