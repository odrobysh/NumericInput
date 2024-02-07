import Foundation

final class NotNumberFilter: TextProcessorProtocol {
  func handle(current: FieldState, prev: FieldState, config: FieldConfig) -> FieldState {
    let wholeNumber = current.value.components(separatedBy: "\(config.decimalSeparator)")[0]
    let wholeNumberRange = current.value.range(of: wholeNumber)
    let number = current.value.replacingOccurrences(of: config.thousandSeparator, with: "", range: wholeNumberRange)
    if Double(number) != nil || current.value.isEmpty || current.value == config.decimalSeparator {
      return current
    } else {
      return prev
    }
  }
}
