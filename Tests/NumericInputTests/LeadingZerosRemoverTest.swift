@testable import NumericInput
import XCTest

final class LeadingZerosRemoverTest: XCTestCase {
  private let delegate = LeadingZerosRemover()
  private let config = FieldConfig(
    numbersBeforeDecimalSeparator: 10,
    numbersAfterDecimalSeparator: 2,
    thousandSeparator: ",",
    decimalSeparator: "."
  )
  func testStartsFromOnlyOneZeroBeforeDecimalSeparator() {
    // Given
    let current = FieldState(value: "0.0", cursorPosition: 3)
    let prev = FieldState(value: "0.0", cursorPosition: 3)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, current)
  }

  func testStartsFromNumber() {
    // Given
    let current = FieldState(value: "10", cursorPosition: 3)
    let prev = FieldState(value: "0", cursorPosition: 3)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, current)
  }

  func testValueThatContainsDecimalSeparator() {
    // Given
    let current = FieldState(value: "000.12", cursorPosition: 3)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = FieldState(value: "0.12", cursorPosition: 1)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testValueCanNotStartWithZero() {
    // Given
    let current = FieldState(value: "00012", cursorPosition: 3)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = FieldState(value: "12", cursorPosition: 0)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testValueCanNotHaveOnlyTwoZeroes() {
    // Given
    let current = FieldState(value: "00", cursorPosition: 2)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = FieldState(value: "0", cursorPosition: 1)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testShouldRemoveLeadingZero() {
    // Given
    let current = FieldState(value: "01", cursorPosition: 2)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = FieldState(value: "1", cursorPosition: 1)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }

  func testShouldRemoveLeadingZeroWithDecimalSeparator() {
    // Given
    let current = FieldState(value: "01.12", cursorPosition: 2)
    let prev = FieldState(value: "", cursorPosition: 0)
    let expected = FieldState(value: "1.12", cursorPosition: 1)

    // When
    let actual = delegate.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, expected)
  }
}
