@testable import UIKitComponents
import XCTest

final class ThousandSeparatorsSetterTest: XCTestCase {
  private let delegate = ThousandSeparatorsSetter()
  private let config = FieldConfig(
    numbersBeforeDecimalSeparator: 10,
    numbersAfterDecimalSeparator: 2,
    thousandSeparator: ",",
    decimalSeparator: "."
  )

  func testCorrectDecimalSeparatorByLocalSet() {
    // Given
    let current = FieldState(value: "1111", cursorPosition: 4)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = FieldState(value: "1,111", cursorPosition: 5)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testWhenCursorAtTheTail() {
    // Given
    let current = FieldState(value: "1000000.00", cursorPosition: 10)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = FieldState(value: "1,000,000.00", cursorPosition: 12)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testStartCursorPositionIs1() {
    // Given
    let current = FieldState(value: "1000,000", cursorPosition: 2)
    let prev = FieldState(value: "100,000", cursorPosition: 1)
    let expected = FieldState(value: "1,000,000", cursorPosition: 3)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testStartCursorPositionIs3() {
    // Given
    let current = FieldState(value: "1,00,000", cursorPosition: 2)
    let prev = FieldState(value: "1,000,000", cursorPosition: 3)
    let expected = FieldState(value: "100,000", cursorPosition: 1)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testStartCursorPositionIs5AfterThousandSeparator() {
    // Given
    let current = FieldState(value: "1,000000", cursorPosition: 5)
    let prev = FieldState(value: "1,000,000", cursorPosition: 6)
    let expected = FieldState(value: "100,000", cursorPosition: 3)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testStartCursorPositionIs1AfterThousandSeparator() {
    // Given
    let current = FieldState(value: "1000", cursorPosition: 1)
    let prev = FieldState(value: "1,000", cursorPosition: 2)
    let expected = FieldState(value: "0", cursorPosition: 1)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testStartCursorPositionIs1AfterFirstLetter() {
    // Given
    let current = FieldState(value: ",234,567", cursorPosition: 0)
    let prev = FieldState(value: "1,234,567", cursorPosition: 1)
    let expected = FieldState(value: "234,567", cursorPosition: 0)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testValueWithTrailingDecimalSeparator() {
    // Given
    let current = FieldState(value: "1234567.", cursorPosition: 8)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = FieldState(value: "1,234,567.", cursorPosition: 10)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }
}
