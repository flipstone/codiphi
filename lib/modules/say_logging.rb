module SayLogging
  include R18n::Helpers
  
  @@suppress = false

  def say(string)
    unless @@suppress
      puts " - #{string}"
    end
  end

  def warn(string)
    unless @@suppress
      puts " ! #{t.log.warn}: #{string}"
    end
  end

  def say_ok(string, &block)
    unless @@suppress
      print " - #{string} .. "
      STDOUT.flush
    end

    begin
      yield if block
      puts "#{t.ok}" unless @@suppress
    rescue Exception
      puts "#{t.fail}" unless @@suppress
    raise
    end
  end
  
  def suppress_log(hide=true)
    @@suppress = hide
  end
  
end