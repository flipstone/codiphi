def validate_list(list)
  schematic_path = list["list"]["schematic"]
  schematic_data = read_schematic(schematic_path)
  node_tree = parse_codex(schematic_data)
  
  node_tree.validate(list)
  
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