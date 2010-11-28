bin_path = File.expand_path(File.dirname(__FILE__))
BASE_PATH = File.join(bin_path, '../')

require 'json'
require 'yaml'
require 'polyglot'
require 'treetop'
require 'r18n-core'

Dir["#{BASE_PATH}lib/codiphi/*.rb"].each {|file| require file }
Dir["#{BASE_PATH}lib/modules/*.rb"].each {|file| require file }
Dir["#{BASE_PATH}lib/codiphi/**/*.rb"].each {|file| require file }

include SayLogging
