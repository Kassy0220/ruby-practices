# frozen_string_literal: true
require 'debug'
def count_stdin(stdin, params)
  text = stdin.read
  line = count_line(text) if params[:count_line]
  word = count_word(text) if params[:count_word]
  byte = count_byte(text) if params[:count_byte]

  format_model = create_format(params).gsub(/ %<name>s/, '')
  format(format_model, line: line, word: word, byte: byte)
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
    file[:byte] = count_byte(text) if params[:count_byte]

    counting_results.push file
  end
  
  if counting_results.size >= 2
    total = {}
    ## TODO: メソッドに切り出す??
    total[:name] = 'total'
    total[:line] = counting_results.sum { |file| file[:line] } if params[:count_line]
    total[:word] = counting_results.sum { |file| file[:word] } if params[:count_word]
    total[:byte] = counting_results.sum { |file| file[:byte] } if params[:count_byte]
    counting_results.push total
  end

  format_model = create_format(params)
  counting_results.map do |file|
    format(format_model, line: file[:line], word: file[:word], byte: file[:byte], name: file[:name])
  end.join("\n")
end

def count_line(text)
  text.count("\n")
end

def count_word(text)
  text.scan(/\S+/).size
end

def count_byte(text)
  text.bytesize
end

def create_format(params)
  format_model = []
  format_model.push '%<line>8d' if params[:count_line]
  format_model.push '%<word>8d' if params[:count_word]
  format_model.push '%<byte>8d' if params[:count_byte]
  format_model.push ' %<name>s' 
  format_model.join
end
