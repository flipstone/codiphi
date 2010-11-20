require 'rspec'

class CodiphiNode < Treetop::Runtime::SyntaxNode
  @@log_suppression = false

  def log(string)
    unless @@log_suppression
      print " - #{string} .. "
      STDOUT.flush
    end
  end

  def log_ok
    puts "OK" unless @@log_suppression
  end
  
  def self.suppress_log(hide=true)
    @@log_suppression = hide
  end
end