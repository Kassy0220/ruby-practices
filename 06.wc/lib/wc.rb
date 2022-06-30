# frozen_string_literal: true

require 'optparse'

def main(target_files)
  counting_results = []

  target_files.each do |target_file|
    file = {}
    file[:filename] = target_file

    file[:line] = count_lines(target_file)    # if params[:r]

    counting_results.push file
  end

  total_lines = counting_results.sum { |file| file[:line] }
  total = { filename: 'total', line: total_lines }
  counting_results.push total if counting_results.size >=2

  counting_results.map do |filerecord|
    "#{filerecord[:line].to_s.rjust(8)} #{filerecord[:filename]}"
  end.join("\n")
end

def count_lines(target_file)
  IO.read(target_file).count("\n")
end
