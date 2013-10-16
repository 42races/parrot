require 'optparse'

require 'parrot/version'
require 'parrot/builder'
require 'parrot/logger'

module Parrot
  require 'parrot/builder'

  class Parrot
    SUB_COMMANDS = %w( new build watch )

    def initialize(args = [])
      @options = { quiet: false }
      extract_options!(args)
      command = args.shift
      exit_if_invalid(command)
      @logger = ParrotLogger.new(@options[:quiet])
      Builder.new(command)
    end

    def log(message)
      @logger.log(message)
    end

    def self.usage
      puts 'Usage: parrot <subcommand> options'
    end

    def exit_if_invalid(command)
      exit! if command.nil?
      Parrot.usage; exit! unless SUB_COMMANDS.include?(command)
    end

    def quiet?
      @options[:quiet]
    end

    private

    def extract_options!(args)
      OptionParser.new do |opts|
        opts.on('-q', '--quiet', 'Quiet mode') { @options[:quiet] = true }
        opts.on_tail('-v', '--version', 'Prints version information') { puts("Parrot #{VERSION}") }
        opts.on_tail('-h', '--help', 'HELP TEXT') { puts 'Help message' }
      end.parse!(args)
    end
  end
end