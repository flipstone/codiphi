require_relative 'spec_helper.rb'

describe CodiphiParser, "cost_measure" do
  parser = CodiphiParser.new

  it "accepts cost_measure string" do
    parser.should generate_node_for 'cost_measure "pants"'
  end

end
