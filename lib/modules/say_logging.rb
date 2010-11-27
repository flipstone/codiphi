module SayLogging

  @@suppress = false

  def say(string)
    unless @@suppress
      puts " - #{string}"
    end
  end

  def warn(string)
    unless @@suppress
      puts " ! Warning: #{string}"
    end
  end

  def say_ok(string, &block)
    unless @@suppress
      print " - #{string} .. "
      STDOUT.flush
    end
    begin
      yield if block
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