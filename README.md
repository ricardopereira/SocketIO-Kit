# ![SocketIO-Kit Logo](https://github.com/ricardopereira/SocketIO-Kit/blob/master/Logo/SocketIOKit.png?raw=true =36x36) SocketIO-Kit

SocketIO-Kit is a [Socket.io](http://socket.io) iOS client with type safe, clean syntax and speed in mind. WebSocket is the only transport that is implemented and it uses [SwiftWebSocket](https://github.com/tidwall/SwiftWebSocket).

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Version](https://img.shields.io/cocoapods/v/SocketIOKit.svg?style=flat)](http://cocoapods.org/pods/SocketIOKit)

## Installation

#### <img src="https://cloud.githubusercontent.com/assets/432536/5252404/443d64f4-7952-11e4-9d26-fc5cc664cb61.png" width="24" height="24"> [Carthage]

[Carthage]: https://github.com/Carthage/Carthage

```ruby
github "ricardopereira/SocketIO-Kit"
```

Then run `carthage update`.

Follow the current instructions in [Carthage's README][carthage-installation]
for up to date installation instructions.

[carthage-installation]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

#### <img src="https://dl.dropboxusercontent.com/u/11377305/resources/cocoapods.png" width="24" height="24"> [CocoaPods]

[CocoaPods]: http://cocoapods.org

To install it, simply add the following line to your **Podfile**:

```ruby
pod "SocketIOKit"
```

You will also need to make sure you're opting into using frameworks:

```ruby
use_frameworks!
```

Then run `pod install` with CocoaPods 0.36 or newer.

#### Manually

[Download](https://github.com/ricardopereira/SocketIO-Kit/archive/master.zip) the project and copy the `SocketIO-Kit` folder into your project and use the `Source` files. You need [Runes] v2.0.0 (Swift 1.2) framework to run SocketIO-Kit because it uses infix operators for monadic functions and you need [SwiftWebSocket] v0.1.18 (Swift 1.2).

There is no need for `import SocketIOKit` when manually installing.

[Runes]: https://github.com/thoughtbot/Runes
[SwiftWebSocket]: https://github.com/tidwall/SwiftWebSocket

## Requirements

* iOS 8.0+ / Mac OS X 10.10+
* Xcode 6.3 (Swift 1.2)

⚠️ Swift 2.0 version, please use branch [`Swift2`](https://github.com/ricardopereira/SocketIO-Kit/tree/Swift2).

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
}.on(.TransportError) {
    switch $0 {
    case .Failure(let error):
        println("WebSocket error: \(error)")
    default:
        break
    }
}.on(.Connected) { result in
    println("Connected")
    socket.emit(.ChatMessage, withMessage: "I'm iOS")
}.on(.Disconnected) { result in
    switch result {
    case .Message(let reason):
        println("Disconnected: \(reason)")
    default:
        break
    }
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

## Features
###### To implement

- [ ] Reconnect automatically
- [ ] Complete documentation
- [ ] Test on iOS 7.0+ and Mac OS X 10.9+
- [ ] BDD Tests

## Debugging

You can opt into seeing messages by supplying the DEBUG flag. Just add `-D DEBUG` in `Build Settings > Swift Compiler - Custom Flags: Other Swift Flags`.

## Contributing

See the [CONTRIBUTING] document. Thank you, [contributors]!

[CONTRIBUTING]: CONTRIBUTING.md
[contributors]: https://github.com/ricardopereira/SocketIO-Kit/graphs/contributors

## Author

Ricardo Pereira, [@ricardopereiraw](https://twitter.com/ricardopereiraw)

## License

It is free software and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE
