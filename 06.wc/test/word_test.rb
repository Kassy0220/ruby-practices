# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require_relative '../lib/wc'

class WordTest < Minitest::Test
  def test_a_file_words
    target_file_path = 'test/fixtures/sample.txt'
    expected = `wc -w #{target_file_path}`
    params = { count_word: true }
    assert_output(expected) { puts count_files([target_file_path], params) }
  end

  def test_two_files_words
    skip("これから実装予定")
  end

  def test_stdin_words
    skip("これから実装予定")
  end
end
