#SocketIO-Kit

###### Version 0.1 - Work in progress...

###Usage

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
    case .Message(let message):
        println("Finally: \(message)")
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
let john = Person("John")

socket.emit(.Login, withObject: john)
```
