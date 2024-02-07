@testable import UIKitComponents
import XCTest

final class NotNumberFilterTest: XCTestCase {
  private let delegate = NotNumberFilter()
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

  func testCorrectValueWithThousandSeparator() {
    // Given
    let current = FieldState(value: "1,111.0", cursorPosition: 3)
    let prev = FieldState(value: "0.0", cursorPosition: 3)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, current)
  }

  func testCecimalSeparatorOnly() {
    // Given
    let current = FieldState(value: ".", cursorPosition: 3)
    let prev = FieldState(value: "0.0", cursorPosition: 3)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, current)
  }

  func testNotANumber() {
    // Given
    let current = FieldState(value: "abc", cursorPosition: 3)
    let prev = FieldState(value: "12", cursorPosition: 2)
    let expected = FieldState(value: "12", cursorPosition: 2)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testEmptyString() {
    // Given
    let current = FieldState(value: "", cursorPosition: 0)
    let prev = FieldState(value: "2", cursorPosition: 1)
    let expected = FieldState(value: "", cursorPosition: 0)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testValueWithThousandSeparatorInDecimalPart() {
    // Given
    let current = FieldState(value: "34,343.3,4", cursorPosition: 10)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = prev

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testValueWithFewDecimalSeparators() {
    // Given
    let current = FieldState(value: "34,343.3.4", cursorPosition: 10)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = prev

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testValueWithoutADecimalSeparator() {
    // Given
    let current = FieldState(value: "123", cursorPosition: 3)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = current

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }
}
