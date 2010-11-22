def emit(data)
  output_hash = transform(data)
  JSON.generate(output_hash)
end

def transform(data)
  tree = render_tree_from_data(data)
  list_data = data["list"] 
  tree.transform(list_data,Hash.new)
  return {
    list: list_data
  }
end

def render_tree_from_data(data)
  raise "List file must include a root-level 'list' element." unless data["list"]   

  say "inspecting list for schematic" do
    raise "List element must include a 'schematic' element." unless data["list"]["schematic"]
  end
  
  schematic_path = data["list"]["schematic"]
  schematic_data = read_schematic(schematic_path)
  node_tree = Codiphi::Parser.parse(schematic_data)
  # puts " - codex.count: #{node_tree.elements.count}"
  # puts " - declaration_list: #{node_tree.declaration_list.class}"
  # puts " - list #{node_tree.list.class}"
  # p node_tree
  node_tree
end

def read_json(path)
  data = ""
  f = File.open(path, "r")
  f.each_line do |line|
      data += line
  end
  JSON.parse(data)
end

def read_schematic(path)
  data = ""
  codex_name = path.split('/').last
  full_path = "schematics/#{path}/#{codex_name}.cdx"
  say "reading schematic at #{full_path}" do
    f = File.open(full_path, "r")
    f.each_line do |line|
        data += line
    end
  end
  data
end