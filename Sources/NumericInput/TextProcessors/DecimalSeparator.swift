final class DecimalSeparator: TextProcessorProtocol {
  func handle(current: FieldState, prev: FieldState, config: FieldConfig) -> FieldState {
    var str = String(current.value)
    var position = UInt(current.cursorPosition)

    while str.contains("\(config.decimalSeparator)\(config.decimalSeparator)") {
      str = str.replacingOccurrences(
        of: "\(config.decimalSeparator)\(config.decimalSeparator)",
        with: "\(config.decimalSeparator)"
      )
      position -= 1
    }

    if str.components(separatedBy: config.decimalSeparator).count > 2 {
      return prev
    }

    return FieldState(value: str, cursorPosition: position)
  }
}
