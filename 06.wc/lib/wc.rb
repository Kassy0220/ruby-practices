# frozen_string_literal: true

def count_stdin(params)
  text = $stdin.read

  counting_result = save_counting_result(params, text: text)

  format_model = create_format(params)
  format(format_model, line: counting_result[:line], word: counting_result[:word], byte: counting_result[:byte], name: '').rstrip
end

def count_files(argv, params)
  target_files = argv
  counting_results = []

  target_files.each do |target_file|
    text = IO.read(target_file)
    counting_results.push save_counting_result(params, target_file: target_file, text: text)
  end

  counting_results.push save_counting_result(params, result_array: counting_results) if counting_results.size >= 2

  format_model = create_format(params)
  counting_results.map do |file|
    format(format_model, line: file[:line], word: file[:word], byte: file[:byte], name: file[:name])
  end.join("\n")
end

def save_counting_result(params, target_file: false, text: false, result_array: false)
  file = {}
  # ファイル・標準入力をカウントする or カウントを合計する
  file[:name] = text ? target_file : 'total'
  params.each_key.with_object(file) do |option, file|
    key = option.to_s.gsub(/count_/, '').to_sym
    file[key] = text ? CounterModule.public_send(option.to_s, text) : result_array.sum { |file_hash| file_hash[key] }
  end
end

def create_format(params)
  format_model = []
  format_model.push '%<line>8d' if params[:count_line]
  format_model.push '%<word>8d' if params[:count_word]
  format_model.push '%<byte>8d' if params[:count_byte]
  format_model.push ' %<name>s'
  format_model.join
end

module CounterModule
  class << self
    def count_line(text)
      text.count("\n")
    end

    def count_word(text)
      text.scan(/\S+/).size
    end

    def count_byte(text)
      text.bytesize
    end
  end
end
