def emit(data)
  tree = render_tree_from_data(data)
  # tree.emit(data["list"])
end

def render_tree_from_data(data)
  raise "List file must include a root-level 'list' element." unless data["list"]   

  say "inspecting list for schematic" do
    unless data["list"]["schematic"]
      puts "FAILED"
      raise "List element must include a 'schematic' element."
    end
  end
  
  schematic_path = data["list"]["schematic"]
  schematic_data = read_schematic(schematic_path)
  node_tree = Codiphi::Parser.parse(schematic_data)
  # p node_tree
  puts " - codex.count: #{node_tree.elements.count}"
  puts " - declaration_list: #{node_tree.declaration_list.class}"
  puts " - list #{node_tree.list.class}"
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