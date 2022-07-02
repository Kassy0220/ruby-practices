# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require_relative '../lib/wc'

class WordTest < Minitest::Test
  def test_count_a_file_words
    target_file_path = 'test/fixtures/sample.txt'
    expected = `wc -w #{target_file_path}`
    params = { count_word: true }
    assert_output(expected) { puts count_files([target_file_path], params) }
  end

  def test_count_two_files_words
    first_target_file_path = 'test/fixtures/sample.txt'
    second_target_file_path = 'test/fixtures/second_sample.txt'
    expected = `wc -w #{first_target_file_path} #{second_target_file_path}`
    params = { count_word: true }
    assert_output(expected) { puts count_files([first_target_file_path, second_target_file_path], params) }
  end

  def test_count_stdin_words
    text = 'RuboCop is a Ruby static code analyzer (a.k.a. linter) and code formatter. Out of the box it will enforce many of the guidelines outlined in the community Ruby Style Guide.'
    stdin = "<<EOS
    #{text}
EOS\n"
    expected = `wc -w #{stdin}`
    $stdin = StringIO.new("text")
    params = { count_word: true }
    assert_output(expected) { puts count_stdin($stdin, params) }
  end
end
