#SocketIO-Kit

###### Version 1.0 Alpha

SocketIO-Kit is a [Socket.io](http://socket.io) iOS client with type safe, clean syntax and speed in mind.

### Installation

#### Carthage

(work in progress)

#### CocoaPods

(work in progress)

#### Manually

[Download](https://github.com/ricardopereira/SocketIO-Kit/archive/master.zip) the project and copy the `SocketIO-Kit` folder into your project to use it in.

## Usage

```swift
// Type safety events
enum AppEvents: String, Printable {
    case ChatMessage = "chat message"
    case GetImage = "getimage"
    case Image = "image"
    
    var description: String {
        return self.rawValue
    }
}

// Mutable
var socket: SocketIO<AppEvents>!
socket = SocketIO(url: "http://localhost:8000/")

// or 
// Immutable
let socket = SocketIO<AppEvents>(url: "http://localhost:8000/")

socket.on(.ConnectError) {
    switch $0 {
    case .Failure(let error):
        println(error)
    default:
        break
    }
}.on(.Connected) { (arg: SocketIOArg) -> () in
    println("Connected")
}

socket.on(.ChatMessage, withCallback: { (arg: SocketIOArg) -> () in
    switch arg {
    case .Message(let message):
        println("Remote: \(message)")
    default:
        println("Not supported")
    }
})

socket.connect()

socket.emit(.ChatMessage, withMessage: "I'm iOS")
```

----

**Retrieving an image**

```js
// NodeJS Server
var io = require('socket.io')(http)

io.on('connection', function(socket) {
  socket.on('getimage', function(msg) {
    // Image
    fs.readFile(__dirname + '/image.png', function(err, buf){
      // It's possible to embed binary data within arbitrarily-complex objects
      socket.emit('image', { image: true, buffer: buf.toString('base64') });
    });
  });
});
```

```swift
// SocketIO-Kit Client
socket.on(.Image) {
    switch $0 {
    case .JSON(let json):
        if let image = json["buffer"] as? String >>- Utilities.base64EncodedStringToUIImage {
            println(image)
        }
    default:
        println("Not supported")
    }
}
```

----

**Working with structs**

```swift
struct ImageInfo: SocketIOObject {
    
    let buffer: String
    
    init(buffer: String) {
        self.buffer = buffer
    }
    
    init(dict: NSDictionary) {
        self.init(buffer: dict["buffer"] as! String)
    }
    
    var asDictionary: NSDictionary {
        return ["buffer": buffer]
    }
    
}
```

```swift
// Example using ImageInfo
socket.on(.Image) {
    switch $0 {
    case .JSON(let json):
        let imageInfo = ImageInfo(dict: json) //<---
        
        if let image = imageInfo.buffer >>- Utilities.base64EncodedStringToUIImage {
            println(image)
        }
    default:
        println("Not supported")
    }
}
```

----

**Working with classes**

```swift
class Person: SocketIOObject {
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    convenience required init(dict: NSDictionary) {
        self.init(name: dict["name"] as! String)
    }
    
    var asDictionary: NSDictionary {
        return ["name": name]
    }
    
}
```

```swift
// Example sending John instance
let john = Person(name: "John")

socket.emit(.Login, withObject: john)
```

## License (MIT)

Copyright (c) 2015 - Ricardo Pereira

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
