require 'polyglot'
require 'treetop'

Treetop.load "/Users/scranky/dev/codiphi/lib/codiphi"

RSpec::Matchers.define :parse do |a_string|
  match do |parser|
    !parser.parse(a_string).nil?
  end
  failure_message_for_should do |parser|
    "Unable to parse expected legal input.\n#{parser.failure_reason}" 
  end
  failure_message_for_should_not do |parser|
    "Incorrectly parsed expected illegal input." 
  end
end
