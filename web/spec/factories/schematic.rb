Factory.define :schematic do |f|
  f.name "test-schematic"
  f.body %{
# models are optional, technically
# a model element requires:
#   - an identifier 
#
# Attributes block is optional and 
# may be declared ad hoc
# 
# attr 'cost' will be used to calculate
# list cost if list includes model
#
model :hero {
  + cost 100
}

# list requirement
# the list element is required
# list block allows one or more (expects/permits) instructions
# allows one or more attribute declarations
#
list { 
  + cost_measure :points
  expects 1 model :hero
}
  }
end
