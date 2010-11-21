require_relative 'spec_helper.rb'

describe CodiphiParser, "full schematics" do
  it "parses hero1" do
    Codiphi::Parser.should parse read_codex("hero1/hero1.cdx")
  end
  it "parses hero1a" do
    Codiphi::Parser.should parse read_codex("hero1a/hero1a.cdx")
  end

end
