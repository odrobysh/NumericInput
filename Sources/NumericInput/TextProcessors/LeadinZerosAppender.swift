import Foundation

final class LeadingZerosAppender: TextProcessorProtocol {
  func handle(current: FieldState, prev: FieldState, config: FieldConfig) -> FieldState {
    var res = current
    if current.value.starts(with: config.decimalSeparator) {
      let mutableValue = NSMutableString(string: current.value)
      mutableValue.insert("0", at: 0)
      res = FieldState(
        value: String(mutableValue),
        cursorPosition: res.cursorPosition + 1
      )
    }

    return res
  }
}
