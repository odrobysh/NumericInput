final class LeadingZerosRemover: TextProcessorProtocol {
  func handle(current: FieldState, prev: FieldState, config: FieldConfig) -> FieldState {
    let condition = defineCondition(current: current, config: config)
    var res = current
    var str = String(res.value)
    var position = Int(current.cursorPosition)
    while condition(str) {
      str = String(str.dropFirst())
      position -= 1
    }

    if position < 0 {
      position = 1
    }

    res = FieldState(value: str, cursorPosition: UInt(position))

    return res
  }

  private func defineCondition(current: FieldState, config: FieldConfig) -> (String) -> Bool {
    var condition: (String) -> Bool
    if current.value.contains(config.decimalSeparator), current.value.starts(with: "0") {
      condition = { (current: String) in
        current.starts(with: "0") && !current.starts(with: "0\(config.decimalSeparator)")
      }
    } else if current.value.contains(config.decimalSeparator) {
      condition = { (current: String) in
        current.starts(with: "00")
      }
    } else {
      condition = { (current: String) in
        current.starts(with: "0") && current.count > 1
      }
    }

    return condition
  }
}
