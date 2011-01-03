require_relative 'spec_helper.rb'

describe Codiphi::Parser, "comments" do

  it "accepts whole line comment" do
    Codiphi::Parser.should parse %{# this is allowed\n}
    Codiphi::Parser.should parse %{#\n}
    Codiphi::Parser.should parse %{# with carriage return\r\n}
    Codiphi::Parser.should parse %{#this too}
  end

  it "allows multiple line comments" do
    Codiphi::Parser.should parse %{# this is allowed\n#\n#\n#woo woo\n}
  end
  
end
