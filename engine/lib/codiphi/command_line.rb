module Codiphi
  class CommandLine
    extend R18n::Helpers

    def self.run(args, stdout, stderr)
      require 'optparse'
      require 'ostruct'

      #
      # parse options
      #
      args << "-h" if args.empty?
      options, unparsed_args = options_parse(args, stdout)
      options.yaml_file = unparsed_args.first if unparsed_args.first

      R18n.set(R18n::I18n.new(options.locale, "#{BASE_PATH}/r18n"))
      SayLogging.suppress_log(!options.verbose)

      #
      # load file
      #
      data = {}
      say_ok t.bin.loading(options.yaml_file) do
        data = Codiphi::Support.read_yaml(options.yaml_file)
      end

      if (options.schematic)
        schematic = Codiphi::Support.read_schematic_data(options.schematic)
      end

      engine = Codiphi::Engine.new(data, schematic, options.locale)

      unless (options.no_validate)
        engine.completion_transform
        engine.validate
      else
        say t.bin.no_validation
        engine.completion_transform
      end
      stdout.puts YAML::dump(engine.emitted_data)
    end

    def self.options_parse(args, stdout)
      # The options specified on the command line will be collected in *options*.
      # We set default values here.
      options = OpenStruct.new
      options.no_validate = false
      options.verbose = false
      options.locale = 'en'

      opts = OptionParser.new do |opts|
        opts.banner = "Usage: codiphi [options] YAML_FILE"
        opts.separator ""
        opts.separator "Specific options:"

        opts.on("-l", "--locale LOCALE", "Use messages localized to LOCALE") do |l|
          options.locale = l
        end

        opts.on("-s", "--schematic PHI_FILE", "Process against PHI_FILE (ignoring schematic tag in list)") do |s|
          options.schematic = s
        end

        opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
          options.verbose = v
        end

        opts.on("-x", "--no-validate", "Run without checking schematic assertions.") do |v|
          options.no_validate = !v
        end

        opts.separator ""
        opts.separator "Common options:"

        opts.on_tail("-h", "--help", "Show this message") do
          stdout.puts opts
          exit
        end

        # Another typical switch to print the version.
        opts.on_tail("--version", "Show version") do
          stdout.puts "v#{Codiphi::Engine::Version.join('.')}"
          exit
        end
      end

      foo = opts.parse(args)
      return options, foo
    end
  end
end
