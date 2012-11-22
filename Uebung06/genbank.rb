#! /usr/bin/env ruby
require 'optparse'
require 'pp'

GB_IDS = ["LOCUS", "DEFINITION", "ACCESSION", "VERSION",
          "KEYWORDS", "SOURCE", "REFERENCE","FEATURES",
          "BASE COUNT", "ORIGIN"]

def parse_options(args)

  options_used = Hash.new
  options = Hash.new
  options[:inputfile] = ''
  options[:selecttop] = []
  options[:echo] = false
  options[:search] = //
  
  option_parser = OptionParser.new do |opts|
    opts.banner = "usage: #{$0} options"
    # inputfile-argument
    opts.on("--inputfile <file>", 
            "Filename of Genebank file to parse") do |filename|
        if options_used.has_key? :inputfile
          raise RuntimeError, "option --inputfile specified more than once!"
        end
        options[:inputfile] = filename
        options_used[:inputfile] = true
      end

    # genbank-toplevel-indentifier
    opts.on("--selecttop <entry>[,<entry>...]", Array,
            "at least one Genebank top-level identifier") do |topids|
      if options_used.has_key? :selecttop
        raise RuntimeError, "option --selecttop specified more than once!"
      end
      options[:selecttop] = topids
      options_used[:selecttop] = true
    end

    # echo-mode
    opts.on("--echo", "echo-mode on") do |echo|
      if options_used.has_key? :echo
        raise RuntimeError, "option --echo specified more than once!"
      end
      options[:echo] = echo
      options_used[:echo] = true
    end
    
    # search with regular expression
    opts.on("--search <regexp>", Regexp,
            "search mode with regular expression") do |regexp|
      if options_used.has_key? :search
        raise RuntimeError, "option --search specified more than once!"
      end
      options[:search] = regexp
      options_used[:search] = true
    end

    # help message
    opts.on_tail("-h","--help", "Shows this message") do |echo|
      puts opts
      exit 0
    end
  end

  option_parser.parse! args

  # --inputfile is mandatory
  if not options_used.has_key? :inputfile
    raise RuntimeError, "option --inputfile <file> is mandatory!"
  end

  # --echo and --search must not be used at the same time
  if options_used.has_key? :echo and options_used.has_key? :search
    raise RuntimeError, "-- search and -- echo must not be used at the same time!"
  end

  # identify all not-allowed genbank identifier
  not_allowed = options[:selecttop].select {|entry| not GB_IDS.index entry}
  if not not_allowed.empty?
    raise RuntimeError, "#{not_allowed} is not an allowed Genbank identifier!"
  end

  return options
end

# if no options are given => request help
if ARGV.empty?
  parse_options(["-h"])
end

# parse ARGV and print error messages
begin
  options = parse_options(ARGV)
rescue => err
  STDERR.puts "ERROR: #{err}"
  exit 1
end

# the options have to be checked if they are default

pp options

# try opening and reading file
begin
  file = File.open(options[:inputfile])
  content = file.readlines
  file.close
rescue
  STDERR.puts "ERROR: could not open file #{options[:inputfile]}"
  exit 1
end
