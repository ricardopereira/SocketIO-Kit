#SocketIO-Kit

###### Version 0.1 - Work in progress...

###Usage

```swift
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
        
        socket.on("chat message", withCallback: { (arg: SocketIOArg) -> (SocketIOResult) in
            switch arg {
            case .Message(let message):
                println("Remote: \(message)")
            default:
                println("Not supported")
            }
            return SocketIOResult.Success(status: 0)
        })
        
        socket.connect()
        
        socket.emit("chat message", withMessage: "I'm iOS")
```

**Image**

```swift
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
