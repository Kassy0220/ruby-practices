# frozen_string_literal: true

require 'optparse'
require_relative '../lib/list_command'

opt = OptionParser.new
options = {}

opt.on('-a') { |v| options[:dot_match] = v }
opt.on('-r') { |v| options[:reverse] = v }
opt.on('-l') { |v| options[:long_format] = v }
opt.parse!(ARGV)

searched_path = ARGV[0] || '.'
puts ListCommand.list_paths(searched_path, options)
