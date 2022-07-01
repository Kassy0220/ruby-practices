# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require_relative '../lib/wc'

class MultipleOptionsTest < Minitest::Test
  def test_lines_and_words_a_file
    target_file_path = 'test/fixtures/sample.txt'
    expected = `wc -l -w #{target_file_path}`
    params = { count_line: true, count_word: true }
    assert_output(expected) { puts count_files([target_file_path], params) }
  end

  def test_lines_and_words_two_files
    skip("これから実装予定")
  end
end
