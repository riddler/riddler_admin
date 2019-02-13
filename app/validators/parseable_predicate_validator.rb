class ParseablePredicateValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    return if value.blank?
    Predicator.parse value
  rescue Racc::ParseError, Predicator::Lexer::ScanError
    record.errors[attribute] << (options[:message] || "is not a valid predicate")
  end
end
