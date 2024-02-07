import UIKit

public class NumericTextField: UITextField {
  public var onNumericValueUpdated: ((_ number: String) -> Void)?
  public var didBeginEditing: (() -> Void)?
  var textFieldDelegate: ThousandSeparatedTextFieldDelegate?

  public convenience init(font: UIFont, color: UIColor, maxIntegerSymbols: Int = 10, maxFractionalSymbols: Int = 2) {
    self.init()

    self.font = font
    textColor = color
    textAlignment = .right
    keyboardType = maxFractionalSymbols == 0 ? .numberPad : .decimalPad
    textFieldDelegate = ThousandSeparatedTextFieldDelegate(
      decimalsAfterDot: maxFractionalSymbols,
      decimalsBeforeDot: maxIntegerSymbols
    )
    delegate = textFieldDelegate
    textFieldDelegate?.onNumericValueUpdated = { [weak self] text in
      guard let onNumericValueUpdated = self?.onNumericValueUpdated else { return }

      onNumericValueUpdated(text)
    }
    textFieldDelegate?.didBeginEditing = { [weak self] in
      self?.didBeginEditing?()
    }
  }

  public init() {
    super.init(frame: .zero)

    translatesAutoresizingMaskIntoConstraints = false
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
