@testable import NumericInput
import XCTest

class CommonTextProcessorTest: XCTestCase {
  var processor: CommonTextProcessor!
  let config = FieldConfig(numbersBeforeDecimalSeparator: 10, numbersAfterDecimalSeparator: 5, thousandSeparator: ",", decimalSeparator: ".")
  let defaultPreviousState = FieldState(value: "", cursorPosition: 0)

  override func setUp() {
    processor = CommonTextProcessor()
  }

  func testHandleCases() throws {
    // Setup tests
    let testCases = [
      HandleTestInput(prev: defaultPreviousState,
                      next: FieldState(value: "1", cursorPosition: 1),
                      expected: FieldState(value: "1", cursorPosition: 1)),

      HandleTestInput(prev: defaultPreviousState,
                      next: FieldState(value: "1111", cursorPosition: 4),
                      expected: FieldState(value: "1,111", cursorPosition: 5)),

      HandleTestInput(prev: defaultPreviousState,
                      next: FieldState(value: "2222222", cursorPosition: 7),
                      expected: FieldState(value: "2,222,222", cursorPosition: 9)),

      HandleTestInput(prev: FieldState(value: "111", cursorPosition: 3),
                      next: FieldState(value: "123aa", cursorPosition: 4),
                      expected: FieldState(value: "111", cursorPosition: 3)),

      HandleTestInput(prev: defaultPreviousState,
                      next: FieldState(value: "1.11111", cursorPosition: 7),
                      expected: FieldState(value: "1.11111", cursorPosition: 7)),

      HandleTestInput(prev: FieldState(value: "1.11111", cursorPosition: 7),
                      next: FieldState(value: "1.111111", cursorPosition: 8),
                      expected: FieldState(value: "1.11111", cursorPosition: 7)),

      HandleTestInput(prev: defaultPreviousState,
                      next: FieldState(value: "1,1111", cursorPosition: 6),
                      expected: FieldState(value: "11,111", cursorPosition: 6)),

      HandleTestInput(prev: defaultPreviousState,
                      next: FieldState(value: "111,1111", cursorPosition: 8),
                      expected: FieldState(value: "1,111,111", cursorPosition: 9)),

      HandleTestInput(prev: defaultPreviousState,
                      next: FieldState(value: "1.1", cursorPosition: 3),
                      expected: FieldState(value: "1.1", cursorPosition: 3)),

      HandleTestInput(prev: defaultPreviousState,
                      next: FieldState(value: "12,345,678.9", cursorPosition: 12),
                      expected: FieldState(value: "12,345,678.9", cursorPosition: 12)),

      HandleTestInput(prev: defaultPreviousState,
                      next: FieldState(value: "123456789.1", cursorPosition: 11),
                      expected: FieldState(value: "123,456,789.1", cursorPosition: 13)),

      HandleTestInput(prev: defaultPreviousState,
                      next: FieldState(value: "12,345,678.1234", cursorPosition: 15),
                      expected: FieldState(value: "12,345,678.1234", cursorPosition: 15)),

      HandleTestInput(prev: defaultPreviousState,
                      next: FieldState(value: "1234567.", cursorPosition: 8),
                      expected: FieldState(value: "1,234,567.", cursorPosition: 10)),

      HandleTestInput(prev: defaultPreviousState,
                      next: FieldState(value: "34,343.3,4", cursorPosition: 10),
                      expected: defaultPreviousState),

      HandleTestInput(prev: defaultPreviousState,
                      next: FieldState(value: "34,343.3.4", cursorPosition: 10),
                      expected: defaultPreviousState),

      HandleTestInput(prev: FieldState(value: "1,000", cursorPosition: 1),
                      next: FieldState(value: ",000", cursorPosition: 0),
                      expected: FieldState(value: "0", cursorPosition: 1)),

      HandleTestInput(prev: FieldState(value: "1,000", cursorPosition: 2),
                      next: FieldState(value: "1000", cursorPosition: 1),
                      expected: FieldState(value: "0", cursorPosition: 1)),

      HandleTestInput(prev: FieldState(value: "10,000", cursorPosition: 1),
                      next: FieldState(value: "0,000", cursorPosition: 0),
                      expected: FieldState(value: "0", cursorPosition: 1))
    ]

    // Perform tests
    for testCase in testCases {
      performHandleTest(input: testCase)
    }
  }

  fileprivate func performHandleTest(input: HandleTestInput) {
    // When
    let result = processor.handle(current: input.next, prev: input.prev, config: config)

    // Then
    XCTAssertEqual(input.expected, result)
  }
}

private struct HandleTestInput {
  let prev: FieldState
  let next: FieldState
  let expected: FieldState

  init(prev: FieldState, next: FieldState, expected: FieldState) {
    self.prev = prev
    self.next = next
    self.expected = expected
  }
}
