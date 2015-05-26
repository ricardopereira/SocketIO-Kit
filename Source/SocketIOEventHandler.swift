//
//  SocketIOEventHandler.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

public class SocketIOEventHandler: SocketIOReceiver {
    
    private lazy var activeEvents = [String: SocketIOCallback]()
    private lazy var globalEvents = [SocketIOCallback]()
    
    final func performEvent(event: String, withMessage message: String) {
        // Call current callback
        if let currentCallback = activeEvents[event] {
            #if DEBUG
                println("--- \(SocketIOName): Event handler")
                println("call event: \"\(event)\"")
            #endif
            dispatch_async(dispatch_get_main_queue()) {
                currentCallback(SocketIOArg.Message(message: message))
            }
        }
        else {
            #if DEBUG
                println("--- \(SocketIOName): Event handler")
                println("call event: \"\(event)\" - none")
            #endif
        }
    }
    
    final func performEvent(event: String, withError error: SocketIOError) {
        // Call current callback
        if let currentCallback = activeEvents[event] {
            #if DEBUG
                println("--- \(SocketIOName): Event handler")
                println("call event: \"\(event)\"")
            #endif
            dispatch_async(dispatch_get_main_queue()) {
                currentCallback(SocketIOArg.Failure(error))
            }
        }
        else {
            #if DEBUG
                println("--- \(SocketIOName): Event handler")
                println("call event: \"\(event)\" - none")
            #endif
        }
    }
    
    final func performEvent(event: String, withList list: NSArray) {
        // Call current callback
        if let currentCallback = activeEvents[event] {
            #if DEBUG
                println("--- \(SocketIOName): Event handler")
                println("call event: \"\(event)\"")
            #endif
            dispatch_async(dispatch_get_main_queue()) {
                currentCallback(SocketIOArg.List(list: list))
            }
        }
        else {
            #if DEBUG
                println("--- \(SocketIOName): Event handler")
                println("call event: \"\(event)\" - none")
            #endif
        }
    }
    
    final func performEvent(event: String, withJSON json: NSDictionary) {
        // Call current callback
        if let currentCallback = activeEvents[event] {
            #if DEBUG
                println("--- \(SocketIOName): Event handler")
                println("call event: \"\(event)\"")
            #endif
            dispatch_async(dispatch_get_main_queue()) {
                currentCallback(SocketIOArg.JSON(json: json))
            }
        }
        else {
            #if DEBUG
                println("--- \(SocketIOName): Event handler")
                println("call event: \"\(event)\" - none")
            #endif
        }
    }
    
    final func performGlobalEvents(message: String) {
        #if DEBUG
            println("--- \(SocketIOName): Event handler")
            println("call global events: \(globalEvents.count)")
        #endif
        for callback in globalEvents {
            dispatch_async(dispatch_get_main_queue()) {
                callback(SocketIOArg.Message(message: message))
            }
        }
    }
    
    public final func on(event: SocketIOEvent, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        return self.on(event.description, withCallback: callback)
    }

    public final func on(event: String, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        // Check current callback
        if let currentCallback = activeEvents[event] {
            #if DEBUG
                println("--- \(SocketIOName): Event handler")
                println("set event \"\(event)\" with new callback")
            #endif
        }
        else {
            #if DEBUG
                println("--- \(SocketIOName): Event handler")
                println("set callback event \"\(event)\"")
            #endif
        }
        // Set new callback
        activeEvents[event] = callback
        return self
    }
    
    public final func onAny(callback: SocketIOCallback) -> SocketIOEventHandler {
        #if DEBUG
            println("--- \(SocketIOName): Event handler")
            println("append global event")
        #endif
        // Set new callback
        globalEvents.append(callback)
        return self
    }
    
    public final func off() -> SocketIOEventHandler {
        #if DEBUG
            println("--- \(SocketIOName): Event handler")
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
