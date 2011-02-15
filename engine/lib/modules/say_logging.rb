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

  def say_ok(string)
    unless @@suppress
      print " - #{string} .. "
      STDOUT.flush
    end

    begin
      (yield if block_given?).tap do
        puts "#{t.ok}" unless @@suppress
      end
    rescue Exception
      puts "#{t.fail}" unless @@suppress
      raise
    end
  end
  
  def suppress_log(hide=true)
    @@suppress = hide
  end
  
end
