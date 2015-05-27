//
//  SocketIOUtilities.swift
//  Smartime
//
//  Created by Ricardo Pereira on 12/05/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#if os(iOS)
import UIKit
#else
import Foundation
#endif

import Runes

public class SocketIOUtilities {
    
    // MARK: base64EncodedStringToUIImage
    
    static private let arrayToJSONData : NSArray -> NSData? = {
        NSJSONSerialization.dataWithJSONObject($0, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
    }
    
    static private let dataToJSONString : NSData -> NSString? = {
        NSString(data: $0, encoding: NSUTF8StringEncoding)
    }
    
    static private let getJSONString : NSString -> String? = {
        $0 as String
    }
    
    static public let arrayToJSON : NSArray -> String? = {
        $0 >>- arrayToJSONData >>- dataToJSONString >>- getJSONString
    }

    
    
    // MARK: base64EncodedStringToUIImage
    
    static private let decodeBuffer : String -> NSData? = {
        NSData(base64EncodedString: $0, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
    }

    #if os(iOS)
    static private let base64ToUIImage : NSData -> UIImage? = {
        UIImage(data: $0)
    }
    
    static public let base64EncodedStringToUIImage : String -> UIImage? = {
        $0 >>- decodeBuffer >>- base64ToUIImage
    }
    #endif
    
}

internal func hasValue<T>(value: T?) -> Bool {
    switch (value) {
    case .Some(_): return true
    case .None: return false
    }
}