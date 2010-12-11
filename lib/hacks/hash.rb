class Hash
  def is_named_type?(name, type)
    name == self[Codiphi::SchematicNameKey] && 
    type == self[Codiphi::SchematicTypeKey] 
  end
end