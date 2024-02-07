@testable import NumericInput
import XCTest

final class LeadingZerosAppenderTest: XCTestCase {
  private let delegate = LeadingZerosAppender()
  private let config = FieldConfig(
    numbersBeforeDecimalSeparator: 10,
    numbersAfterDecimalSeparator: 2,
    thousandSeparator: ",",
    decimalSeparator: "."
  )

  func testCorrectValue() {
    // Given
    let current = FieldState(value: "0.0", cursorPosition: 3)
    let prev = FieldState(value: "0.0", cursorPosition: 3)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, current)
  }

  func testValueThatStartsFromTheDecimalSeparator() {
    // Given
    let current = FieldState(value: ".12", cursorPosition: 1)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = FieldState(value: "0.12", cursorPosition: 2)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }
}
