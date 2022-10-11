# frozen_string_literal: true

require 'optparse'
require_relative '../lib/list'
require_relative '../lib/builder'
require_relative '../lib/content'

opt = OptionParser.new
options = {}

opt.on('-a') { |v| options[:dot_match] = v }
opt.on('-r') { |v| options[:reverse] = v }
opt.parse!(ARGV)

searched_path = ARGV[0] || '.'
puts List.list(searched_path, options)
