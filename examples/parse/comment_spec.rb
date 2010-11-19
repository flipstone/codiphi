require_relative 'spec_helper.rb'

describe CodiphiParser, "comments" do
  parser = CodiphiParser.new

  it "accepts whole line comment" do
    parser.should parse %{# this is allowed\n}
    parser.should parse %{#\n}
    parser.should parse %{#this too}
  end

  it "allows multiple line comments" do
    parser.should parse %{# this is allowed\n#\n#\n#woo woo\n}
  end
  
end
