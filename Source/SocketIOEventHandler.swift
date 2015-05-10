//
//  SocketIOEventHandler.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

class SocketIOEventHandler: SocketIOReceiver {
    
    private lazy var activeEvents = [String: SocketIOCallback]()
    private lazy var globalEvents = [SocketIOCallback]()
    
    final func performEvent(event: String, withMessage message: String) {
        // Call current callback
        if let currentCallback = activeEvents[event] {
            #if DEBUG
                println("--- \(SocketIO.name): Event handler")
                println("call event: \"\(event)\"")
            #endif
            currentCallback(SocketIOArg.Message(message: message))
        }
        else {
            #if DEBUG
                println("--- \(SocketIO.name): Event handler")
                println("no events")
            #endif
        }
    }
    
    final func performEvent(event: String, withError error: SocketIOError) {
        // Call current callback
        if let currentCallback = activeEvents[event] {
            #if DEBUG
                println("--- \(SocketIO.name): Event handler")
                println("call event: \"\(event)\"")
            #endif
            currentCallback(SocketIOArg.Failure(error))
        }
        else {
            #if DEBUG
                println("--- \(SocketIO.name): Event handler")
                println("no events")
            #endif
        }
    }
    
    final func performEvent(event: String, withJSON json: NSDictionary) {
        // Call current callback
        if let currentCallback = activeEvents[event] {
            #if DEBUG
                println("--- \(SocketIO.name): Event handler")
                println("call event: \"\(event)\"")
            #endif
            currentCallback(SocketIOArg.JSON(json: json))
        }
        else {
            #if DEBUG
                println("--- \(SocketIO.name): Event handler")
                println("no events")
            #endif
        }
    }
    
    final func performGlobalEvents(message: String) {
        #if DEBUG
            println("--- \(SocketIO.name): Event handler")
            println("call global events: \(globalEvents.count)")
        #endif
        for callback in globalEvents {
            callback(SocketIOArg.Message(message: message))
        }
    }
    
    func on(event: SocketIOEvent, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        return self.on(event.description, withCallback: callback)
    }

    func on(event: String, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        // Check current callback
        if let currentCallback = activeEvents[event] {
            #if DEBUG
                println("--- \(SocketIO.name): Event handler")
                println("set event \"\(event)\" with new callback")
            #endif
        }
        else {
            #if DEBUG
                println("--- \(SocketIO.name): Event handler")
                println("set callback event \"\(event)\"")
            #endif
        }
        // Set new callback
        activeEvents[event] = callback
        return self
    }
    
    func onAny(callback: SocketIOCallback) -> SocketIOEventHandler {
        #if DEBUG
            println("--- \(SocketIO.name): Event handler")
            println("append global event")
        #endif
        // Set new callback
        globalEvents.append(callback)
        return self
    }
    
    func off() -> SocketIOEventHandler {
        #if DEBUG
            println("--- \(SocketIO.name): Event handler")
            println("remove all events")
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
