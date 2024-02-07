final class DigitLimiter: TextProcessorProtocol {
  func handle(current: FieldState, prev: FieldState, config: FieldConfig) -> FieldState {
    let pureNumber = current.value.replacingOccurrences(of: config.thousandSeparator, with: "")
    if pureNumber.contains("\(config.decimalSeparator)") {
      let sepString = pureNumber.components(separatedBy: "\(config.decimalSeparator)")
      if sepString[0].count > config.numbersBeforeDecimalSeparator {
        return prev
      }

      if sepString[1].count > config.numbersAfterDecimalSeparator {
        return prev
      }
    } else if pureNumber.count > config.numbersBeforeDecimalSeparator {
      return prev
    }

    return current
  }
}
