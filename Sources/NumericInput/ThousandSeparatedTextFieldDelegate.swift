import Foundation
import UIKit

public final class ThousandSeparatedTextFieldDelegate: NSObject, UITextFieldDelegate {
  let textProcessor = CommonTextProcessor()
  let decimalsAfterDot: Int
  let decimalsBeforeDot: Int

  public var onNumericValueUpdated: ((_ number: String) -> Void)?
  public var didBeginEditing: (() -> Void)?

  public init(decimalsAfterDot: Int, decimalsBeforeDot: Int) {
    self.decimalsAfterDot = decimalsAfterDot
    self.decimalsBeforeDot = decimalsBeforeDot
    super.init()
  }

  public func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    guard let text = textField.text else { return false }

    let currentTextValue = getCurrentTextValue(with: range, original: text, replacementString: string)
    let currentCursorPosition = range.location + string.count
    let prevCursorPosition = getPrevCursorPosition(with: range, and: string)
    let current = FieldState(value: currentTextValue, cursorPosition: UInt(currentCursorPosition))
    let prev = FieldState(value: text, cursorPosition: UInt(prevCursorPosition))
    handleInput(on: textField, prev: prev, current: current)
    guard let onNumericValueUpdated else {
      return false
    }

    onNumericValueUpdated(textField.text ?? "")
    return false
  }

  private func getCurrentTextValue(with range: NSRange, original text: String, replacementString: String) -> String {
    let mutableInput = NSMutableString(string: text)
    mutableInput.deleteCharacters(in: range)
    mutableInput.insert(replacementString, at: range.location)
    return String(mutableInput)
  }

  private func getPrevCursorPosition(with range: NSRange, and replacementString: String) -> Int {
    if range.length > replacementString.count {
      return range.location + range.length
    } else {
      return range.location
    }
  }

  private func handleInput(on textField: UITextField, prev: FieldState, current: FieldState) {
    let config = FieldConfig(
      numbersBeforeDecimalSeparator: UInt(decimalsBeforeDot),
      numbersAfterDecimalSeparator: UInt(decimalsAfterDot),
      thousandSeparator: Constants.thousandSeparator,
      decimalSeparator: Constants.decimalSeparator
    )

    let processed = textProcessor.handle(
      current: current,
      prev: prev,
      config: config
    )
    update(textField: textField, with: processed)
  }

  private func update(textField: UITextField, with fieldState: FieldState) {
    textField.text = fieldState.value
    if let positionToSet = textField.position(
      from: textField.beginningOfDocument,
      offset: Int(fieldState.cursorPosition)
    ) {
      textField.selectedTextRange = textField.textRange(from: positionToSet, to: positionToSet)
    } else {
      textField.endEditing(true)
    }
  }

  public func textFieldDidBeginEditing(_ textField: UITextField) {
    didBeginEditing?()
  }
}

private enum Constants {
  // Strings
  static let thousandSeparator = ","
  static let decimalSeparator = "."
}
