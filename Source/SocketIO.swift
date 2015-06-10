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
        session.dataTaskWithRequest(request, completionHandler: completion)?.resume()
    }
    
}

public class SocketIO<T: CustomStringConvertible>: SocketIOReceiver, SocketIOEmitter {
    
    private let url: NSURL
    private let options: SocketIOOptions
    private let connection: SocketIOConnection
    
    /**
    Creates a SocketIO instance providing the URL string of the server.
    
    - parameter url: URL that will be used to establish the transport connection.
    */
    convenience public init(url: String) {
        if let url = NSURL(string: url) {
            self.init(nsurl: url)
        }
        else {
            assertionFailure("\(SocketIOName): Invalid URL")
            self.init(url: "")
        }
    }
    
    /**
    Creates a SocketIO instance with Options.
    
    - parameter url:     URL that will be used to establish the transport connection.
    :param options  Custom options
    
      let options = SocketIOOptions().namespace("/users")
    */
    convenience public init(url: String, withOptions options: SocketIOOptions) {
        if let url = NSURL(string: url) {
            self.init(nsurl: url, withOptions: options, withRequest: SessionRequest(), withTransport: SocketIOWebSocket.self)
        }
        else {
            assertionFailure("\(SocketIOName): Invalid URL")
            self.init(url: "", withOptions: options)
        }
    }
    
    /**
    Creates a SocketIO instance providing the NSURL of the server.
    
    - parameter nsurl: URL that will be used to establish the transport connection.
    */
    convenience public init(nsurl: NSURL) {
        self.init(nsurl: nsurl, withOptions: SocketIOOptions(), withRequest: SessionRequest(), withTransport: SocketIOWebSocket.self)
    }
    
    /**
    Creates a SocketIO instance with Options.
    
    - parameter nsurl:   URL that will be used to establish the transport connection.
    :param options  Custom options
    
      let options = SocketIOOptions().namespace("/users")
    */
    convenience public init(nsurl: NSURL, withOptions options: SocketIOOptions) {
        self.init(nsurl: nsurl, withOptions: options, withRequest: SessionRequest(), withTransport: SocketIOWebSocket.self)
    }

    public init(nsurl: NSURL, withOptions options: SocketIOOptions, withRequest request: SocketIORequester, withTransport transport: SocketIOTransport.Type) {
        url = nsurl
        self.options = options
        connection = SocketIOConnection(options: options, requester: request, transport: transport.self)
    }
    
    
    /**
    Connects to the Socket.io server.
    */
    public final func connect() {
        connection.open(url)
    }
    
    /**
    Disconnects the current connection.
    */
    public final func disconnect() {
        connection.close()
    }
    
    /**
    Reconnects to the Socket.io server. It closes the current connection and establishes a new one.
    */
    public final func reconnect() {
        connection.close()
        connection.open(url)
    }

    
    //MARK: SocketIOEmitter
    
    /**
    Sends a text message to the server.
    
    - parameter event:     Event name provided with SocketIOEvent.
    - parameter message:   Message to send.
    */
    public final func emit(event: SocketIOEvent, withMessage message: String) {
        emit(event.description, withMessage: message)
    }

    /**
    Sends a text message to the server.
    
    - parameter event:     Event name provided with generic type.
    - parameter message:   Message to send.
    */
    public final func emit(event: T, withMessage message: String) {
        emit(event.description, withMessage: message)
    }

    /**
    Sends a text message to the server.
    
    - parameter event:     Event name.
    - parameter message:   Message to send.
    */
    public final func emit(event: String, withMessage message: String) {
        connection.emit(event, withMessage: message)
    }

    /**
    Sends a list of items to the server.
    
    - parameter event:   Event name provided with SocketIOEvent.
    - parameter list:    List of type NSArray to send.
    */
    public final func emit(event: SocketIOEvent, withList list: NSArray) {
        emit(event.description, withList: list)
    }

    /**
    Sends a list of items to the server.
    
    - parameter event:   Event name provided with generic type.
    - parameter list:    List of type NSArray to send.
    */
    public final func emit(event: T, withList list: NSArray) {
        emit(event.description, withList: list)
    }
    
    /**
    Sends a list of items to the server.
    
    - parameter event:   Event name.
    - parameter list:    List of type NSArray to send.
    */
    public final func emit(event: String, withList list: NSArray) {
        connection.emit(event, withList: list)
    }
    
    /**
    Sends a dictionary (key-value) to the server.
    
    - parameter event:   Event name provided with SocketIOEvent.
    - parameter dict:    Key-value object of type NSDictionary to send.
    */
    public final func emit(event: SocketIOEvent, withDictionary dict: NSDictionary) {
        emit(event.description, withDictionary: dict)
    }

    /**
    Sends a dictionary (key-value) to the server.
    
    - parameter event:   Event name provided with generic type.
    - parameter dict:    Key-value object of type NSDictionary to send.
    */
    public final func emit(event: T, withDictionary dict: NSDictionary) {
        emit(event.description, withDictionary: dict)
    }

    /**
    Sends a dictionary (key-value) to the server.
    
    - parameter event:   Event name.
    - parameter dict:    Key-value object of type NSDictionary to send.
    */
    public final func emit(event: String, withDictionary dict: NSDictionary) {
        connection.emit(event, withDictionary: dict)
    }
    
    /**
    Sends a object to the server.
    
    - parameter event:   Event name provided with SocketIOEvent.
    - parameter object:  Object that comply SocketIOObject protocol.
    */
    public final func emit(event: SocketIOEvent, withObject object: SocketIOObject) {
        emit(event.description, withObject: object)
    }
    
    /**
    Sends a object to the server.
    
    - parameter event:   Event name provided with generic type.
    - parameter object:  Object that comply SocketIOObject protocol.
    */
    public final func emit(event: T, withObject object: SocketIOObject) {
        emit(event.description, withObject: object)
    }
    
    /**
    Sends a object to the server.
    
    - parameter event:   Event name provided.
    - parameter object:  Object that comply SocketIOObject protocol.
    */
    public final func emit(event: String, withObject object: SocketIOObject) {
        connection.emit(event, withObject: object)
    }

    
    
    //MARK: SocketIOReceiver
    
    /**
    Callback fired upon a successful event call.
    
    - parameter event:   Event name provided with SocketIOEvent.
    - parameter callback:  Function of type SocketIOCallback.
    */
    public final func on(event: SocketIOEvent, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        return connection.on(event, withCallback: callback)
    }
    
    /**
    Callback fired upon a successful event call.
    
    - parameter event:   Event name provided with generic type.
    - parameter callback:  Function of type SocketIOCallback.
    */
    public final func on(event: T, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        return on(event.description, withCallback: callback)
    }
    
    /**
    Callback fired upon a successful event call.
    
    - parameter event:   Event name provided.
    - parameter callback:  Function of type SocketIOCallback.
    */
    public final func on(event: String, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        return connection.on(event, withCallback: callback)
    }
    
    /**
    Callback fired upon any event is called.
    
    - parameter callback:  Function of type SocketIOCallback.
    */
    public final func onAny(callback: SocketIOCallback) -> SocketIOEventHandler {
        return connection.onAny(callback)
    }
    
    /**
    Remove all callbacks for events.
    */
    public final func off() -> SocketIOEventHandler {
        return connection.off()
    }
    
}
