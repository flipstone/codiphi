module SayLogging

  @@suppress = false

  def say(string)
    unless @@suppress
      print " - #{string} .. "
      STDOUT.flush
    end
    begin
      yield
    rescue Exception
      puts "FAIL" unless @@suppress
      raise 
    end
    puts "OK" unless @@suppress
  end
  
  def suppress_log(hide=true)
    @@suppress = hide
  end
  
end