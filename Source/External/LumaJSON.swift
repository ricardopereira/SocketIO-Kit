//
//  LumaJSON.swift
//  LumaJSON
//
//  Created by Jameson Quave on 2/28/15.
//  Copyright (c) 2015 Lumarow, LLC. All rights reserved.
//

import Foundation

class LumaJSONObject: Printable {
    
    var value: AnyObject?
    
    subscript(index: Int) -> LumaJSONObject? {
        return (value as? [AnyObject]).map { LumaJSONObject($0[index]) }
    }
    
    subscript(key: String) -> LumaJSONObject? {
        return (value as? NSDictionary).map { LumaJSONObject($0[key]) }
    }
    
    subscript(key: String) -> AnyObject? {
        get {
            return self[key]?.value
        }
    }
    
    subscript(key: Int) -> AnyObject? {
        get {
            return self[key]?.value
        }
    }
    
    init(_ value: AnyObject?) {
        self.value = value
    }
    
    var description: String {
        get {
            return "LumaJSONObject: \(self.value)"
        }
    }
}

struct LumaJSON {
    
    static var logErrors = true
    
    static func jsonFromObject(object: [String: AnyObject]) -> String? {
        var err: NSError?
        if let jsonData = NSJSONSerialization.dataWithJSONObject( (object as NSDictionary) , options: nil, error: &err) {
            if let jsonStr = NSString(data: jsonData, encoding: NSUTF8StringEncoding) {
                return jsonStr as String
            }
        }
        else if(err != nil) {
            if LumaJSON.logErrors {
                println( err?.localizedDescription )
            }
        }
        return nil
    }
    
    static func parse(json: String) -> LumaJSONObject? {
        if let jsonData = json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false){
            var err: NSError?
            
            let parsed: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableLeaves, error: &err)
            
            if let parsedArray = parsed as? NSArray {
                return LumaJSONObject(parsedArray)
            }
            
            if let parsedDictionary = parsed as? NSDictionary {
                return LumaJSONObject(parsedDictionary)
            }
            
            if LumaJSON.logErrors && (err != nil) {
                println(err?.localizedDescription)
            }
            
            return LumaJSONObject(parsed)
        }
        return nil
    }
}
