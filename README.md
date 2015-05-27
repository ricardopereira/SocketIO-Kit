# ![SocketIO-Kit Logo](https://github.com/ricardopereira/SocketIO-Kit/blob/master/Logo/SocketIOKit.png?raw=true =36x36) SocketIO-Kit

SocketIO-Kit is a [Socket.io](http://socket.io) iOS client with type safe, clean syntax and speed in mind. WebSocket is the only transport that is implemented and it uses [Starscrem](https://github.com/daltoniam/Starscream).

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Installation

#### [Carthage]

[Carthage]: https://github.com/Carthage/Carthage

```
github "ricardopereira/SocketIO-Kit"
```

Then run `carthage update`.

Follow the current instructions in [Carthage's README][carthage-installation]
for up to date installation instructions.

[carthage-installation]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

#### [CocoaPods]

[CocoaPods]: http://cocoapods.org

(work in progress)

#### Manually

[Download](https://github.com/ricardopereira/SocketIO-Kit/archive/master.zip) the project and copy the `SocketIO-Kit` folder into your project and use the `Source` files. You need [Runes] framework to run SocketIO-Kit because it uses infix operators for monadic functions.

[Runes]: https://github.com/thoughtbot/Runes

## Usage

```swift
import SocketIOKit

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
    socket.emit(.ChatMessage, withMessage: "I'm iOS")
}

socket.on(.ChatMessage) {
    switch $0 {
    case .Message(let message):
        println("Remote: \(message)")
    default:
        println("Not supported")
    }
}

socket.connect()
```

**Options**

```swift
socket = SocketIO(url: "http://localhost:8001/", withOptions: SocketIOOptions().namespace("/gallery"))
```

----

#### Examples

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
        if let image = json["buffer"] as? String >>- SocketIOUtilities.base64EncodedStringToUIImage {
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
        self.init(buffer: dict["buffer"] as! String) //Force casts should be avoided!
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
        
        if let image = imageInfo.buffer >>- SocketIOUtilities.base64EncodedStringToUIImage {
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
        self.init(name: dict["name"] as! String) //Force casts should be avoided!
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

## Debugging

You can opt into seeing messages by supplying the DEBUG flag. Just add `-D DEBUG` in `Build Settings > Swift Compiler - Custom Flags: Other Swift Flags`.

## Contributing

See the [CONTRIBUTING] document. Thank you, [contributors]!

[CONTRIBUTING]: CONTRIBUTING.md
[contributors]: https://github.com/ricardopereira/SocketIO-Kit/graphs/contributors

## License

It is free software and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE
