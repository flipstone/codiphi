require_relative 'spec_helper.rb'

describe CodiphiParser, "full schematics" do
  it "parses hero_1" do
    Codiphi::Parser.should parse read_codex("hero_1/hero_1.cdx")
  end

end
