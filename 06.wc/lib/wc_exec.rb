# frozen_string_literal: true

require 'optparse'

require_relative 'wc'

opt = OptionParser.new

params = { }
opt.on('-l') { |v| params[:count_line] = v }
opt.on('-w') { |v| params[:count_word] = v }
opt.parse!(ARGV)
# オプションが未指定の時は、全てのオプションを実行する
params = { count_line: true, count_word: true } if params.empty?

puts ARGV.empty? ? count_stdin($stdin, params) : count_files(ARGV, params)
