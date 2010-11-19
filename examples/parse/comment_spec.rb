require_relative 'spec_helper.rb'

describe CodiphiParser, "comments" do
  parser = CodiphiParser.new

  it "accepts sameline comment" do
    parser.should generate_node_for '# this is allowed\n'
    parser.should generate_node_for '#\n'
  end

  it "allows multiple line comments" do
    parser.should generate_node_for '# this is allowed\n#\n#\n# woo woo\n'
  end

end
