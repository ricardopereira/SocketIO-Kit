//
//  Tests.swift
//  Tests
//
//  Created by Ricardo Pereira on 22/05/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Quick
import Nimble
import SocketIOKit

class SocketIOKitSpec: QuickSpec {
    override func spec() {
        it("is url error prone") {
            let socket = SocketIO<SocketIOEvent>(nsurl: NSURL(), withOptions: SocketIOOptions(), withRequest: FakeHTTPRequest(), withTransport: FakeTransport.self)
            
            //XCTAssert(false, "Test")
            expect(1 + 1).to(equal(3))
        }
    }
}