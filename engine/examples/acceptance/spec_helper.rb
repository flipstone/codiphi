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

class Array
  def delimited(delimeter)
    stringout = ""
    self.each{ |i| stringout << i.gsub(/"/, '') + delimeter}
    stringout.chomp(delimeter)
  end

  def pretty_node(append=nil)
    if empty?
      if append.nil?
        out = ""
      else
        out = "on <#{append}>"
      end
    else
      out = self.delimited('.')
      out << ".#{append}" if append
      out = "on <#{out}>"
    end
    out
  end

  def deep_diff(other, difflist, keystack)
    unless other.is_a?(Array)
      difflist << "Unexpected elements #{keystack.pretty_node}: #{inspect}" 
      return
    end

    begin
      self_for_comp, other_for_comp = sort, other.sort
    rescue ArgumentError
      self_for_comp, other_for_comp = self, other
    end

    self_for_comp.zip(other_for_comp).each do |v1, v2|
      if v1.respond_to?(:deep_diff) && v2.respond_to?(:deep_diff)
        v1.deep_diff(v2, difflist, keystack.push('[]'))
        keystack.pop
      else
        difflist << "Expected value '#{other[k]}' #{keystack.pretty_node(k)}, but got '#{v}'" unless v1 == v2
      end 
    end

  end
end

class Hash
  def deep_diff(other, difflist, keystack)
    unless other.is_a?(Hash)
      difflist << "Unexpected elements #{keystack.pretty_node}: #{self.keys.inspect}" 
      return
    end

    keydiffs = self.keys - other.keys
    keydiffs += other.keys - self.keys

    if !keydiffs.empty?
      keydiffs.each { |k| 
        difflist << "Unexpected <#{k}:#{self[k]}> #{keystack.pretty_node}" if self.keys.include?(k)
        difflist << "Expected <#{k}:#{other[k]}> #{keystack.pretty_node}" if other.keys.include?(k)
      }
    end
    self.each do |k,v| 
      if v.respond_to?(:deep_diff) && other[k].respond_to?(:deep_diff)
        v.deep_diff(other[k], difflist, keystack.push(k))
        keystack.pop
      else
        # compare the values
        difflist << "Expected value '#{other[k]}' #{keystack.pretty_node(k)}, but got '#{v}'" unless other[k] == v
      end 
    end
  end
end
