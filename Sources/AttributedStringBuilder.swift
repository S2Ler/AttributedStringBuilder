import Foundation
#if os(iOS) || os(watchOS) || os(tvOS)
  import UIKit
  public typealias Font = UIFont
  public typealias Image = UIImage
  public typealias Color = UIColor
#elseif os(macOS)
  import AppKit
  public typealias Font = NSFont
  public typealias Image = NSImage
  public typealias Color = NSColor
#else
  //
#endif

public struct AttributedStringBuilder {
  private var _storage = NSMutableAttributedString()

  private mutating func modifyStorage(block: (NSMutableAttributedString) -> Void) {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _storage.mutableCopy() as! NSMutableAttributedString
    }
    block(_storage)
  }

  public init() {

  }

  /// Resets builder state and return builded attributed string
  public mutating func buildAndReset() -> NSAttributedString {
    let attributedString = _storage
    _storage = NSMutableAttributedString()
    return attributedString
  }

  @discardableResult
  public mutating func append(_ string: String,
                              font: Font? = nil,
                              color: Color? = nil,
                              letterSpacing: Float? = nil,
                              adjustParagraph: Optional<(NSMutableParagraphStyle) -> Void> = nil,
                              adjustAttributes: Optional<(inout [String: AnyObject]) -> Void> = nil) -> AttributedStringBuilder {
    var attributes: [String: AnyObject] = [:]

    if let font = font {
      attributes[NSFontAttributeName] = font
    }

    if let color = color {
      attributes[NSForegroundColorAttributeName] = color
    }

    if let letterSpacing = letterSpacing {
      attributes[NSKernAttributeName] = NSNumber(value: letterSpacing)
    }

    if let adjustParagraph = adjustParagraph {
      let paragraph = NSMutableParagraphStyle()
      adjustParagraph(paragraph)
      attributes[NSParagraphStyleAttributeName] = paragraph
    }

    adjustAttributes?(&attributes)

    append(NSAttributedString(string: string, attributes: attributes))

    return self
  }

  @discardableResult
  public mutating func append(_ attributedString: NSAttributedString) -> AttributedStringBuilder {
    modifyStorage { $0.append(attributedString) }
    return self
  }

  @discardableResult
  public mutating func append(image: Image, verticalDisposition: CGFloat = 0) -> AttributedStringBuilder {
    let iconAttachment = NSTextAttachment()
    iconAttachment.bounds = CGRect(x: 0, y: verticalDisposition,
                                   width: image.size.width, height: image.size.height)
    iconAttachment.image = image
    let iconString = NSAttributedString(attachment: iconAttachment)
    append(iconString)
    return self
  }

  /// Breaks current line
  @discardableResult
  public mutating func newLine(count: Int = 1) -> AttributedStringBuilder {
    return append(String(repeating: "\n", count: count))
  }

  /// Breaks current line and insert an empty line
  @discardableResult
  public mutating func emptyLine() -> AttributedStringBuilder {
    return append("\n\n")
  }

  /// Adds `count` empty space chars
  @discardableResult
  public mutating func space(count: Int = 1) -> AttributedStringBuilder {
    return append(String(repeating: " ", count: count))
  }
}
