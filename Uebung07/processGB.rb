#! /usr/bin/env ruby
require 'optparse'
require 'pp'
require './gbiterator.rb'
require 'parseAnno.rb'
require 'parseFeatures.rb'

GB_IDS = ["LOCUS", "DEFINITION", "ACCESSION", "VERSION",
          "KEYWORDS", "SOURCE", "REFERENCE","FEATURES",
          "BASE COUNT", "ORIGIN","COMMENT"]

# parse commandline options
def parse_options(args)
  options_used = Hash.new
  options = Hash.new
  options[:inputfile] = ''
  options[:selecttop] = GB_IDS # default all IDs
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

# print out genbank hash content (executed if --echo)
def show_genbank(gbhash)
  gbhash.each do |key, value|
    if key == "ORIGIN"
      puts "#{key}\n#{value}"
    elsif not key.match /_old/
      # if a parsed field exists => show that one
      puts "%-12s#{value}" %key
    end
  end
end

# print out genbank hash content if /regex/ matched (executed if --search);
# entry printed only when match
def search_genbank(gbhash, regex)
  hasmatch = false
  output = ""
  gbhash.each do |key, value|
    # only look at non-old fields
    if not key.match /_old/
      # if there is a non-parsed field => use for search
      if gbhash.has_key? "#{key}_old"
        match_val = gbhash["#{key}_old"]
      else
        match_val = value
      end
      if (match = match_val.match(regex))
        hasmatch = true
        output += "#{regex.inspect} matches in"
        if key == "ORIGIN"
          output += " Sequence from #{match.begin(0)+1} to #{match.end(0)}"
        end
        output += "\n"
      end
      if key == "ORIGIN"
        output += "#{key}\n#{value}"
      else
        output += "%-12s#{value}\n" %key
      end
    end
  end
  if hasmatch
    puts output
  end
end

# get a hash of features (feature fields are stored in a Hash)
def get_feature_hash(features)
  feat_hash = {}
  # use parseFeatures.rb to split feature entries
  parse_features(features).each do |feat|
    # get name of feature and range of feature
    # no match checking neccessary (matches verified in parse_features)
    match = feat.match(/^ {5}(\S+)\s+(\S+)/)
    name = match[1]
    range = match[2]
    feat_hash[name] = {name => range}
    # get and split the feature entries
    feat.scan(/^ {21}(\S+)=(.+)\n/).each do |left, right|
      # remove "
      feat_hash[name][left] = right.gsub(/\"/,"")
    end
  end
  return feat_hash
end

# parse fields containing subfields (like REFERENCE or SOURCE)
def parse_subfields(field,key)
  out_hash = {}
  # remove first line and treat rest like an normal annotation
  match = field.match("(.+)\n")
  # if something goes wrong => incorrect subfields
  begin
    firstline = match[1]
    # remove newlines at the beginning (so it looks like top-level ID)
    fields = match.post_match.gsub(/^ {2}/,"")
    out_hash = parse_annotation(fields)
  
    out_hash.each_key do |subkey|
      # and all terminating newlines
      out_hash[subkey].gsub!(/^#{subkey}\s+/, "").chomp!
      # and remove every \n with trailing \s (replace with one blank)
      out_hash[subkey].gsub!(/\n\s*/, " ")
    end
  rescue
    raise RuntimeError, "incorrect formatted subfields!"
  end
  out_hash[key] = firstline
  return out_hash
end

# parse multigb-file with specified options
def parsemultigb(options)
  out_entries = []
  # use genebank iterator for parsed gene bank files
  gbit = GenbankIterator.new(options[:inputfile])
  gbit.each_ann_dna do |ann, dna|
    # parse genebank file annotations to field-indexed hash (method from
    # splitGB.rb)
    parsedgb = parse_annotation(ann)
    # select only fields which are selected in options
    parsedgb = parsedgb.select {|key| options[:selecttop].index(key)}
    parsedgb.each_key do |key|
      # remove KEY at begining and all terminating whitespaces
      parsedgb[key].gsub!(/^#{key}\s+/, "").chomp!
      # and remove every \n with trailing \s (replace with one blank)
      # (unless the keys should be parsed later)
      if key != "FEATURES" and key != "REFERENCE" and key != "SOURCE"
        parsedgb[key].gsub!(/\n\s*/, " ")
      end
    end
    # treat special fields differently
    if parsedgb.has_key? "ORIGIN"
      parsedgb["ORIGIN"] = dna
    end
    # caution: make copy of unparsed subfields (for simple search with regexp)
    if parsedgb.has_key? "FEATURES"
      parsedgb["FEATURES_old"] = parsedgb["FEATURES"].clone
      parsedgb["FEATURES_old"].gsub!(/\n\s*/, " ")
      parsedgb["FEATURES"] = get_feature_hash(parsedgb["FEATURES"])
    end
    if parsedgb.has_key? "SOURCE"
      parsedgb["SOURCE_old"] = parsedgb["SOURCE"].clone
      parsedgb["SOURCE_old"].gsub!(/\n\s*/, " ")
      parsedgb["SOURCE"] = parse_subfields(parsedgb["SOURCE"], "SOURCE")
    end
    if parsedgb.has_key? "REFERENCE"
      parsedgb["REFERENCE_old"] = parsedgb["REFERENCE"].clone
      parsedgb["REFERENCE_old"].gsub!(/\n\s*/, " ")
      parsedgb["REFERENCE"] = parse_subfields(parsedgb["REFERENCE"], "REFERENCE")

    end
    # show all entries, matches or nothing (according to options)
    if options[:echo]
      show_genbank(parsedgb)
    elsif options[:search] != //
      search_genbank(parsedgb, options[:search])
    end

    # and now remove the old fields
    parsedgb = parsedgb.select {|key| not key.match /_old/}

    out_entries.push(parsedgb)
  end

  return out_entries
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

#pp options

# try opening and reading file
begin
  parsed_content = parsemultigb (options)
rescue => err
  STDERR.puts "ERROR: #{err}"
  exit 1
end

#pp parsed_content
