# frozen_string_literal: true

require 'optparse'

def main(target_file)
  counted_results = []

  line_count = count_lines(target_file)
  record = "#{line_count.to_s.rjust(8)} #{target_file}"
  counted_results.push record

  "#{counted_results.join("\n")}\n"
end

def count_lines(target_file)
  IO.read(target_file).count("\n")
end
