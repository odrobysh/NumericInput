import Foundation

class ThousandSeparatorsSetter: TextProcessorProtocol {
  func handle(current: FieldState, prev: FieldState, config: FieldConfig) -> FieldState {
    let numberFormatter = provideNumberFormatter(config: config, current: current)
    let res = handleThousandSeparatorRemovingIfNeeded(current: current, prev: prev, config: config)
    let stringWithoutThousandSeparators = res.value.replacingOccurrences(of: config.thousandSeparator, with: "")
    let hasTrailingDecimalSeparator = hasTrailingDecimalSeparatorInString(
      str: current.value,
      separator: config.decimalSeparator
    )
    if let resDouble = Double(stringWithoutThousandSeparators),
       let formattedText = numberFormatter.string(from: NSNumber(value: resDouble)) {
      let resultText = hasTrailingDecimalSeparator ? formattedText + config.decimalSeparator : formattedText
      return FieldState(
        value: resultText,
        cursorPosition: calculateCursorPosition(
          input: res.value,
          formatted: resultText,
          originalCursorPosition: res.cursorPosition
        )
      )
    }

    return current
  }

  private func hasTrailingDecimalSeparatorInString(str: String, separator: String) -> Bool {
    if let lastSymbol = str.last, String(lastSymbol) == separator {
      return true
    }

    return false
  }

  private func handleThousandSeparatorRemovingIfNeeded(
    current: FieldState,
    prev: FieldState,
    config: FieldConfig
  ) -> FieldState {
    if current.value.starts(with: config.thousandSeparator) {
      return FieldState(value: String(current.value.dropFirst()), cursorPosition: current.cursorPosition)
    }

    guard isThousandSeparatorRemovedFromTheMiddle(
      current: current,
      prev: prev,
      config: config
    ) else { return current }

    let indexToRemove = current.value.index(current.value.startIndex, offsetBy: Int(current.cursorPosition - 1))
    var resStr = current.value
    resStr.remove(at: indexToRemove)
    var resCursorPosition = Int(current.cursorPosition) - 2
    if resCursorPosition < 0 {
      resCursorPosition = 1
    }

    return FieldState(value: resStr, cursorPosition: UInt(resCursorPosition))
  }

  private func provideNumberFormatter(config: FieldConfig, current: FieldState) -> NumberFormatter {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.groupingSeparator = config.thousandSeparator
    numberFormatter.decimalSeparator = config.decimalSeparator
    numberFormatter.minimumFractionDigits = getDecimalsCount(
      input: current.value,
      decimalSeparator: config.decimalSeparator
    )
    return numberFormatter
  }

  private func calculateCursorPosition(input: String, formatted: String, originalCursorPosition: UInt) -> UInt {
    let move = formatted.count - input.count
    if move < 0, formatted == "0" {
      return UInt(1)
    }

    return UInt(Int(originalCursorPosition) + move)
  }

  private func getDecimalsCount(input: String, decimalSeparator: String) -> Int {
    let array = input.components(separatedBy: decimalSeparator)
    if array.count > 1 {
      let decimals = array[1]
      return decimals.count
    }

    return 0
  }

  private func isThousandSeparatorRemovedFromTheMiddle(
    current: FieldState,
    prev: FieldState,
    config: FieldConfig
  ) -> Bool {
    prev.cursorPosition > 0
      && prev.value[Int(prev.cursorPosition - 1)] == config.thousandSeparator
      && prev.cursorPosition > current.cursorPosition
  }
}

private extension StringProtocol {
  subscript(offset: Int) -> String {
    String(self[index(startIndex, offsetBy: offset)])
  }
}
