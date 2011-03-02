require_relative 'spec_helper.rb'

describe CodiphiParser, "full schematics" do
  it "parses hero1" do
    Codiphi::Parser.should parse read_sample_codex("hero1.cdx")
  end

end
