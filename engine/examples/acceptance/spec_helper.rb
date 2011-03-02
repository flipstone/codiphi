require_relative '../spec_helper.rb'
require 'set'

RSpec::Matchers.define :set_match do |h2|
  diff_elements = "none"
  difflist = []
  match do |h1|
    h1.deep_diff(h2, difflist, [])
    difflist.empty?
  end
  failure_message_for_should do |h1|
    %{#{difflist.count} errors in transform output:\n  #{difflist.delimited("\n  ")}} 
  end
  failure_message_for_should_not do |h1|
    "Hash tree was not expected to set_match exactly." 
  end
end

