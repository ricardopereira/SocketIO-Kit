//
//  SocketIOEventHandler.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

protocol SocketIOEventHandlerProtocol {
    
    func on(event: String, withCallback callback: SocketIOCallback) -> SocketIOEventHandler;
    func onAny(callback: SocketIOCallback) -> SocketIOEventHandler;
    func off() -> SocketIOEventHandler;
    
}

class SocketIOEventHandler: SocketIOEventHandlerProtocol {
    
    lazy var activeEvents = [String: SocketIOCallback]()
    lazy var globalEvents = [SocketIOCallback]()
    
    func performEvent(event: String, withMessage message: String) {
        // Call current callback
        if let currentCallback = activeEvents[event] {
            #if DEBUG
                println("Call event: \"\(event)\"")
            #endif
            currentCallback(message)
        }
        else {
            #if DEBUG
                println("No events")
            #endif
        }
    }
    
    func performGlobalEvents(message: String) {
        #if DEBUG
            println("Call global events: \(globalEvents.count)")
        #endif
        for callback in globalEvents {
            callback(message)
        }
    }
    
    func on(event: SocketIOEvent, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        return self.on(event.description, withCallback: callback)
    }

    func on(event: String, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        // Check current callback
        if let currentCallback = activeEvents[event] {
            #if DEBUG
                println("Set event \"\(event)\" with new callback")
            #endif
        }
        else {
            #if DEBUG
                println("Set callback event \"\(event)\"")
            #endif
        }
        // Set new callback
        activeEvents[event] = callback
        return self
    }
    
    func onAny(callback: SocketIOCallback) -> SocketIOEventHandler {
        #if DEBUG
            println("Append global event")
        #endif
        // Set new callback
        globalEvents.append(callback)
        return self
    }
    
    func off() -> SocketIOEventHandler {
        #if DEBUG
            println("Remove all events")
        #endif
        if (activeEvents.count > 0) {
            // Remove all events
            activeEvents = [String: SocketIOCallback]()
        }
        if (globalEvents.count > 0) {
            // Remove all events
            globalEvents = [SocketIOCallback]()
        }
        return self
    }
    
}
