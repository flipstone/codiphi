bin_path = File.expand_path(File.dirname(__FILE__))
BASE_PATH = File.join(bin_path, '../')

require 'json'
require 'yaml'
require 'polyglot'
require 'treetop'
require 'r18n-core'

module Codiphi
  module Tokens
    Schematic = "schematic"
    Type = :schematic_type
    Name = "type"
    Cost = "cost"
    List = "list"
    ListErrors = "list-errors"
    Count = "count"
    Permits = "permits"
    Expects = "expects"
    Addition = '+'
    Removal = '-'
    Assignment = '='
  end
end

Dir["#{BASE_PATH}lib/codiphi/*.rb"].each {|file| require file }
Dir["#{BASE_PATH}lib/modules/*.rb"].each {|file| require file }
Dir["#{BASE_PATH}lib/codiphi/**/*.rb"].each {|file| require file }
Dir["#{BASE_PATH}lib/hacks/*.rb"].each {|file| require file }

include SayLogging
