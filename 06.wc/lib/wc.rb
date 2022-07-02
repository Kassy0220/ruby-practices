# frozen_string_literal: true
require 'debug'
def count_stdin(stdin, params)
  stdin = stdin.read
  lines = stdin.count("\n") if params[:count_line]
  "#{lines.to_s.rjust(8)}"
end

def count_files(argv, params)
  target_files = argv
  counting_results = []

  target_files.each do |target_file|
    text = IO.read(target_file)
    file = {}
    file[:name] = target_file
    file[:line] = count_line(text) if params[:count_line]
    file[:word] = count_word(text) if params[:count_word]

    counting_results.push file
  end
  
  if counting_results.size >= 2
    total = {}
    total[:name] = 'total'
    total[:line] = counting_results.sum { |file| file[:line] } if params[:count_line]
    total[:word] = counting_results.sum { |file| file[:word] } if params[:count_word]
    counting_results.push total
  end

  format_model = create_format(params)
  counting_results.map do |file|
    format(format_model, line: file[:line], word: file[:word], name: file[:name])
  end.join("\n")
end

def count_line(text)
  text.count("\n")
end

def count_word(text)
  text.scan(/\S+/).size
end

def create_format(params)
  format_model = []
  format_model.push '%<line>8d' if params[:count_line]
  format_model.push '%<word>8d' if params[:count_word]
  format_model.push ' %<name>s' 
  format_model.join
end
