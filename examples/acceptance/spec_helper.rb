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
    %{#{difflist.count} errors in tree:\n  #{difflist.delimited("\n  ")}} 
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
end

class Hash
  def deep_diff(other, difflist, keystack)
    if other.nil?
      difflist << "Unexpected elements on node <'#{keystack.delimited('.')}'>: #{self.keys.inspect}" 
      return
    end

    keydiffs = self.keys - other.keys
    keydiffs += other.keys - self.keys
    # puts "diffing keys #{self.keys} - #{other.keys} = #{keydiffs}"

    if !keydiffs.empty?
      keydiffs.each { |k| 
        difflist << "Unexpected node <#{k}:#{self[k]}> on node <#{keystack.delimited('.')}>" if self.keys.include?(k)
        difflist << "Expected node <#{k}:#{other[k]}> on node <#{keystack.delimited('.')}>" if other.keys.include?(k)
      }
    end
    self.each do |k,v| 
      # puts "diffing hashes #{v.class} - #{other[k].class}"
      if v.class == Hash && other[k].class == Hash
        # puts "deep diffing node #{k}"
        v.deep_diff(other[k], difflist, keystack.push(k))
      end 
    end
    keystack.pop
  end
end