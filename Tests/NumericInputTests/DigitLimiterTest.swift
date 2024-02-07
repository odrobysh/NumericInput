@testable import NumericInput
import XCTest

final class DigitLimiterTest: XCTestCase {
  private let delegate = DigitLimiter()
  private let config = FieldConfig(
    numbersBeforeDecimalSeparator: 10,
    numbersAfterDecimalSeparator: 2,
    thousandSeparator: ",",
    decimalSeparator: "."
  )
  func testBothValuesAreInTheValidRange() {
    // Given
    let current = FieldState(value: "111.11", cursorPosition: 6)
    let prev = FieldState(value: "11.11", cursorPosition: 5)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, current)
  }

  func testDecimalSeparatorAtTheEndOfAValue() {
    // Given
    let current = FieldState(value: "12.", cursorPosition: 3)
    let prev = FieldState(value: "12", cursorPosition: 3)
    let expected = FieldState(value: "12.", cursorPosition: 3)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func tesTooManyDigitsBeforeTheDecimalSeparator() {
    // Given
    let current = FieldState(value: "12.432", cursorPosition: 6)
    let prev = FieldState(value: "12.43", cursorPosition: 5)
    let expected = FieldState(value: "12.43", cursorPosition: 5)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testTooManyDigitsBeforeTheDecimalSeparator() {
    // Given
    let current = FieldState(value: "12345678910.", cursorPosition: 12)
    let prev = FieldState(value: "1234567891", cursorPosition: 10)
    let expected = FieldState(value: "1234567891", cursorPosition: 10)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testValueWithoutADecimalSeparator() {
    // Given
    let current = FieldState(value: "3344", cursorPosition: 4)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = FieldState(value: "3344", cursorPosition: 4)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testInputDecimalSeparatorInsideTheValueWithoutADecimalSeparator() {
    // Given
    let current = FieldState(value: "334.455", cursorPosition: 4)
    let prev = FieldState(value: "334455", cursorPosition: 3)
    let expected = FieldState(value: "334455", cursorPosition: 3)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testTooManyDigitsBeforeADecimalSeparator() {
    // Given
    let current = FieldState(value: "11111111111", cursorPosition: 11)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = FieldState(value: "", cursorPosition: 0)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testInputWithSeparators() {
    // Given
    let current = FieldState(value: "12,345,678.9", cursorPosition: 12) // 12 symbols but 9 numbers
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = current

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testInputWithDecimalSeparator() {
    // Given
    let current = FieldState(value: "123456789.1", cursorPosition: 11)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = current

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testInputWithCommonLengthMoreThanMaximumMainPartLength() {
    // Given
    let current = FieldState(value: "1234567890.12", cursorPosition: 12)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = current

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }
}
