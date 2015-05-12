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

// Let's go
var socket: SocketIO<AppEvents>!

socket = SocketIO(url: "http://localhost:8000/")

socket.on(.ConnectError) {
    switch $0 {
    case .Failure(let error):
        println(error)
    default:
        break
    }
    return SocketIOResult.Success(status: 0)
}.on(.Connected) { (arg: SocketIOArg) -> (SocketIOResult) in
    println("Connected")
    return SocketIOResult.Success(status: 0)
}

socket.on(.ChatMessage, withCallback: { (arg: SocketIOArg) -> (SocketIOResult) in
    switch arg {
    case .Message(let message):
        println("Remote: \(message)")
    default:
        println("Not supported")
    }
    return SocketIOResult.Success(status: 0)
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
        let decodeBufferUsingBase64 : String -> NSData? = {
            NSData(base64EncodedString: $0, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        }
        
        let base64ToUIImage : NSData -> UIImage? = {
            UIImage(data: $0)
        }
        
        if let image = json["buffer"] as? String >>- decodeBufferUsingBase64 >>- base64ToUIImage {
            println(image)
        }
    default:
        println("Not supported")
    }
    return SocketIOResult.Success(status: 0)
}
```
