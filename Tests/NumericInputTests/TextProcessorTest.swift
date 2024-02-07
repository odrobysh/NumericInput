@testable import NumericInput
import XCTest

final class TextProcessorTest: XCTestCase {
  private let delegateMock = TextProcessorProtocolMock()
  private let nextDelegateMock = TextProcessorProtocolMock()
  lazy var processor = TextProcessor(delegate: delegateMock)
  lazy var nextProcessorMock = TextProcessorCreatableProtocolMock()

  private let config = FieldConfig(
    numbersBeforeDecimalSeparator: 10,
    numbersAfterDecimalSeparator: 2,
    thousandSeparator: ",",
    decimalSeparator: "."
  )

  override func setUpWithError() throws {
    processor = TextProcessor(delegate: delegateMock)
  }

  func testNextProcessorIsPresent() {
    // Given
    _ = processor.setNext(processor: nextProcessorMock)
    let current = FieldState(value: "0.0", cursorPosition: 3)
    let prev = FieldState(value: "0.0", cursorPosition: 3)
    let resultOfDelegate = FieldState(value: "delegate", cursorPosition: 111)
    let resultOfNextProcessor = FieldState(value: "nextProcessor", cursorPosition: 111)

    delegateMock.handleHandler = { localCurrent, localPrev, localConfig in
      XCTAssertEqual(localCurrent, current)
      XCTAssertEqual(localPrev, prev)
      XCTAssertEqual(localConfig, self.config)
      return resultOfDelegate
    }
    nextProcessorMock.handleHandler = { localCurrent, localPrev, localConfig in
      XCTAssertEqual(localCurrent, resultOfDelegate)
      XCTAssertEqual(localPrev, prev)
      XCTAssertEqual(localConfig, self.config)
      return resultOfNextProcessor
    }

    // When
    let actual = processor.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, resultOfNextProcessor)
    XCTAssertEqual(delegateMock.handleCallCount, 1)
    XCTAssertEqual(nextProcessorMock.handleCallCount, 1)
  }

  func testNextProcessorIsNil() {
    // Given
    let current = FieldState(value: "0.0", cursorPosition: 3)
    let prev = FieldState(value: "0.0", cursorPosition: 3)
    let resultOfDelegate = FieldState(value: "delegate", cursorPosition: 111)

    delegateMock.handleHandler = { localCurrent, localPrev, localConfig in
      XCTAssertEqual(localCurrent, current)
      XCTAssertEqual(localPrev, prev)
      XCTAssertEqual(localConfig, self.config)
      return resultOfDelegate
    }

    // When
    let actual = processor.handle(current: current, prev: prev, config: config)

    // Then
    XCTAssertEqual(actual, resultOfDelegate)
    XCTAssertEqual(delegateMock.handleCallCount, 1)
  }

  private final class TextProcessorProtocolMock: TextProcessorProtocol {
    init() {}

    private(set) var handleCallCount = 0
    var handleHandler: ((FieldState, FieldState, FieldConfig) -> (FieldState))?
    func handle(current: FieldState, prev: FieldState, config: FieldConfig) -> FieldState {
      handleCallCount += 1
      if let handleHandler {
        return handleHandler(current, prev, config)
      }
      fatalError("handleHandler returns can't have a default value thus its handler must be set")
    }
  }

  class TextProcessorCreatableProtocolMock: TextProcessorCreatableProtocol {
    init() {}

    private(set) var handleCallCount = 0
    var handleHandler: ((FieldState, FieldState, FieldConfig) -> (FieldState))?
    func handle(current: FieldState, prev: FieldState, config: FieldConfig) -> FieldState {
      handleCallCount += 1
      if let handleHandler {
        return handleHandler(current, prev, config)
      }
      fatalError("handleHandler returns can't have a default value thus its handler must be set")
    }

    private(set) var setNextCallCount = 0
    var setNextHandler: ((TextProcessorCreatableProtocol) -> (TextProcessorCreatableProtocol))?
    func setNext(processor: TextProcessorCreatableProtocol) -> TextProcessorCreatableProtocol {
      setNextCallCount += 1
      if let setNextHandler {
        return setNextHandler(processor)
      }
      return TextProcessorCreatableProtocolMock()
    }
  }
}
