# frozen_string_literal: true

require 'optparse'

require_relative 'wc'

params = ARGV.getopts('l')
## TODO : 標準入力にも対応できるようにする。
target_file = ARGV[0]

puts main(target_file)
