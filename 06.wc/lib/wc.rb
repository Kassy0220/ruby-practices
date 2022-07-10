# frozen_string_literal: true

def count_stdin(params)
  text = $stdin.read
  counting_result = {}

  save_counting_result(counting_result, params, text)

  format_model = create_format(params)
  format(format_model, line: counting_result[:line], word: counting_result[:word], byte: counting_result[:byte], name: '').rstrip
end

def count_files(argv, params)
  target_files = argv
  counting_results = []

  target_files.each do |target_file|
    text = IO.read(target_file)
    file = {}

    file[:name] = target_file
    save_counting_result(file, params, text)

    counting_results.push file
  end

  if counting_results.size >= 2
    total = {}
    save_sum_of_each_results(total, counting_results, params)
    counting_results.push total
  end

  format_model = create_format(params)
  counting_results.map do |file|
    format(format_model, line: file[:line], word: file[:word], byte: file[:byte], name: file[:name])
  end.join("\n")
end

def save_counting_result(result_hash, params, text)
  params.each_key do |option|
    key = option.to_s.gsub(/count_/, '').to_sym
    result_hash[key] = CounterModule.public_send(option.to_s, text)
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

def save_sum_of_each_results(total, counting_results, params)
  total[:name] = 'total'
  params.each_key do |option|
    key = option.to_s.gsub(/count_/, '').to_sym
    total[key] = counting_results.sum { |file| file[key] }
  end
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
