@testable import UIKitComponents
import XCTest

final class DecimalSeparatorTest: XCTestCase {
  private let delegate = DecimalSeparator()
  private let config = FieldConfig(
    numbersBeforeDecimalSeparator: 10,
    numbersAfterDecimalSeparator: 2,
    thousandSeparator: ",",
    decimalSeparator: "."
  )
  func testStartFromValueAfterDecimalSeparator() {
    let current = FieldState(value: "0.1", cursorPosition: 3)
    let prev = FieldState(value: "0.1", cursorPosition: 3)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, current)
  }

  func testTwoDecimalSeparatorsInARow() {
    let current = FieldState(value: "1..", cursorPosition: 3)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = FieldState(value: "1.", cursorPosition: 2)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testInsertingDecimalSeparatorAfterAnotherSeparator() {
    let current = FieldState(value: "1.23.", cursorPosition: 5)
    let prev = FieldState(value: "1.23", cursorPosition: 4)
    let expected = FieldState(value: "1.23", cursorPosition: 4)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testInsertingDecimalSeparatorBeforeAnotherSeparator() {
    let current = FieldState(value: "2.34.56", cursorPosition: 2)
    let prev = FieldState(value: "234.56", cursorPosition: 1)
    let expected = FieldState(value: "234.56", cursorPosition: 1)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testDifferentDecimalSeparator() {
    let config = FieldConfig(
      numbersBeforeDecimalSeparator: 10,
      numbersAfterDecimalSeparator: 2,
      thousandSeparator: "!",
      decimalSeparator: "?"
    )
    let current = FieldState(value: "1??", cursorPosition: 3)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = FieldState(value: "1?", cursorPosition: 2)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }
}
