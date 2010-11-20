def validate_list(list)
  build_symantic_tree(list).validate(list["list"])
  
end

def cost(list)
  cost = build_symantic_tree(list).cost(list["list"])
  puts "List costs #{cost}"
end

def build_symantic_tree(list)
  raise "List file must include a root-level 'list' element." unless list["list"]   

  flash "inspecting list for schematic"
  unless list["list"]["schematic"]
    puts "FAILED"
    raise "List element must include a 'schematic' element."
  end
  puts "OK"
  
  schematic_path = list["list"]["schematic"]
  schematic_data = read_schematic(schematic_path)
  node_tree = parse_codex(schematic_data)
end


def parse_codex(schematic_data)
  flash "parsing codex"
  parser = CodiphiParser.new
  node_tree = parser.parse(schematic_data)
  puts "OK"
  return node_tree
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
  flash "reading schematic at #{full_path}"
  
  f = File.open(full_path, "r")
  f.each_line do |line|
      data += line
  end
  puts "OK"
  data
end

def flash(value)
  print " - #{value} .. "
  STDOUT.flush
end