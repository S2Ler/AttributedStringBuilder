# Example 

```swift
var b = AttributedStringBuilder()
b.append("Hello")
b.append(image: Image(named: "AnImage")!)
b.append("World!", font: Font.boldSystemFont(ofSize: 14), color: .red)
let attributedString: NSAttributedString = b.buildAndReset()
```
