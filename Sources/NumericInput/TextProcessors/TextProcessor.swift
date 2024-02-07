import Foundation

class TextProcessor: TextProcessorCreatableProtocol {
  var handler: TextProcessorProtocol?
  var next: TextProcessorProtocol?

  init(delegate: TextProcessorProtocol) {
    handler = delegate
  }

  func handle(current: FieldState, prev: FieldState, config: FieldConfig) -> FieldState {
    guard let delegate = handler else { return FieldState(value: "", cursorPosition: 0) }

    var res = delegate.handle(current: current, prev: prev, config: config)
    if let next {
      res = next.handle(current: res, prev: prev, config: config)
    }

    return res
  }

  func setNext(processor: TextProcessorCreatableProtocol) -> TextProcessorCreatableProtocol {
    next = processor
    return processor
  }
}
