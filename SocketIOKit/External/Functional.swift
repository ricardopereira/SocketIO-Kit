//
//  Functional.swift
//  Smartime
//
//  Created by Ricardo Pereira on 10/05/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

infix operator >>- { associativity left precedence 135 }

internal func >>-<A, B>(a: A?, f: A -> B?) -> B?
{
    return bind(a, f)
}

internal func bind<A, B>(a: A?, f: A -> B?) -> B?
{
    if let x = a {
        return f(x)
    } else {
        return .None
    }
}
