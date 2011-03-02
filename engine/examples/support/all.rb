Dir[File.join(File.dirname(__FILE__), %w(** *.rb))].each do |f|
  require f
end
