def Node(name, input)
  Codiphi::Parser.parse(input, root: name)
end
