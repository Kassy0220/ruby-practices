# frozen_string_literal: true
require 'debug'
def count_stdin(stdin, params)
  stdin = stdin.read
  lines = stdin.count("\n") if params[:count_line]
  "#{lines.to_s.rjust(8)}"
end

def count_files(argv, params)
  counting_results = []
  target_files = argv

  target_files.each do |target_file|
    file = {}
    file[:filename] = target_file
    file[:line] = count_lines(target_file) if params[:count_line]

    counting_results.push file
  end
 
  total_lines = counting_results.sum { |file| file[:line] }
  total = { filename: 'total', line: total_lines }
  counting_results.push total if counting_results.size >= 2

  counting_results.map do |filerecord|
    "#{filerecord[:line].to_s.rjust(8)} #{filerecord[:filename]}"
  end.join("\n")
end

def count_lines(target_file)
  IO.read(target_file).count("\n")
end
