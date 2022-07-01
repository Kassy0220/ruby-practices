# frozen_string_literal: true

require 'optparse'

require_relative 'wc'

params = ARGV.getopts('l')

puts ARGV.empty? ? count_stdin($stdin) : count_files(ARGV)
