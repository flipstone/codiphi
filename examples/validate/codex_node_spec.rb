require_relative '../spec_helper.rb'

describe CodexNode do
  
  describe "cost_measure" do
    xit "defaults to 'points'" do
    end
    xit "detects correct value" do
    end
  end  
  
  describe "validate" do
    it "exceptions missing demands element(s)" do
      data = %{
        {
          "nothin":
          {
            "id":"hero",
            "count":1
          }
        }
      }
    
      lambda do
        codexnode = CodexNode.new("foo",3)
        codexnode.validate(JSON.parse(data))
      end.should raise_error
    
    end

    it "validates legal element(s)" do
      data = %{
        {
          "cost_measure":"buttons"
          "nothin":
          {
            "id":"hero",
            "count":1
          }
        }
      }
    
      lambda do
        codexnode = CodexNode.new("foo",3)
        codexnode.validate(JSON.parse(data))
      end.should raise_error
    
    end
  end
end
