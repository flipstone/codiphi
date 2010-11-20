require_relative '../spec_helper.rb'

describe CodexNode, "validate" do

  it "confirms list element" do
    json = read_json("test/one_man_army.json")
    codexnode = CodexNode.new("foo",3)
    codexnode.validate(json)
  end
  
  it "exceptions missing list element" do
     data = %{{
        "foo":
        {
            "model":{
                "id":"hero",
                "description":"Neo",
                "count":1
            }
        }
    }}
    
    lambda do
      codexnode = CodexNode.new("foo",3)
      codexnode.validate(JSON.parse(data))
    end.should raise_error
    
  end
  
end
