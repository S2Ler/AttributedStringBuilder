import XCTest
@testable import AttributedStringBuilder

class AttributedStringBuilderTests: XCTestCase {
  func testSimple() {
    var builder = AttributedStringBuilder()
    builder.append("Hello")
    let result = builder.buildAndReset()
    XCTAssertEqual(result.string, "Hello")
    let emptyResult = builder.buildAndReset()
    XCTAssertEqual(emptyResult.string, "")
  }

  func testSpace() {
    var builder = AttributedStringBuilder()
    builder.append("Hello")
    builder.space(count: 4)
    let result = builder.buildAndReset()
    XCTAssertEqual(result.string, "Hello    ")
  }

  func testNewLine() {
    var builder = AttributedStringBuilder()
    builder.append("Hello")
    builder.newLine(count: 4)
    let result = builder.buildAndReset()
    XCTAssertEqual(result.string, "Hello\n\n\n\n")
  }

  func testEmptyLine() {
    var builder = AttributedStringBuilder()
    builder.append("Hello")
    builder.emptyLine()
    let result = builder.buildAndReset()
    XCTAssertEqual(result.string, "Hello\n\n")
  }

  func testDoubleAppend() {
    var builder = AttributedStringBuilder()
    builder.append("Hello")
    builder.append(",")
    builder.space()
    builder.append("World!")
    let result = builder.buildAndReset()
    XCTAssertEqual(result.string, "Hello, World!")
  }

  func testImage() {
    var builder = AttributedStringBuilder()
    builder.append("Hello")
    builder.append(image: Image())
    let result = builder.buildAndReset()
    XCTAssertTrue(result.containsAttachments)
  }

  func testBuild() {
    var builder = AttributedStringBuilder()
    builder.append("Hello")
    let result = builder.build()
    XCTAssertEqual(result.string, "Hello")
    builder.append("!")
    let result2 = builder.build()
    XCTAssertEqual(result2.string, "Hello!")
  }

  // TODO: Test attributes
}
