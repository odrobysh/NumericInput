protocol TextProcessorProtocol {
  func handle(current: FieldState, prev: FieldState, config: FieldConfig) -> FieldState
}

protocol TextProcessorCreatableProtocol: TextProcessorProtocol {
  func setNext(processor: TextProcessorCreatableProtocol) -> TextProcessorCreatableProtocol
}
