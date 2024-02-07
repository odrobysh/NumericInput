import Foundation

final class CommonTextProcessor: TextProcessorProtocol {
  func handle(current: FieldState, prev: FieldState, config: FieldConfig) -> FieldState {
    let processorsChain = TextProcessor(delegate: NotNumberFilter())
    _ = processorsChain
      .setNext(processor: TextProcessor(delegate: DigitLimiter()))
      .setNext(processor: TextProcessor(delegate: DecimalSeparator()))
      .setNext(processor: TextProcessor(delegate: LeadingZerosRemover()))
      .setNext(processor: TextProcessor(delegate: LeadingZerosAppender()))
      .setNext(processor: TextProcessor(delegate: ThousandSeparatorsSetter()))
    return processorsChain.handle(current: current, prev: prev, config: config)
  }
}
