# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require_relative '../lib/wc'

class WordTest < Minitest::Test
  def test_count_words_in_a_file
    target_file_path = 'test/fixtures/sample.txt'
    expected = `wc -w #{target_file_path}`
    params = { count_word: true }
    assert_output(expected) { puts count_files([target_file_path], params) }
  end

  def test_count_words_in_two_files
    first_target_file_path = 'test/fixtures/sample.txt'
    second_target_file_path = 'test/fixtures/second_sample.txt'
    expected = `wc -w #{first_target_file_path} #{second_target_file_path}`
    params = { count_word: true }
    assert_output(expected) { puts count_files([first_target_file_path, second_target_file_path], params) }
  end

  def test_count_words_in_empty_file
    target_file_path = 'test/fixtures/empty.txt'
    expected = `wc -w #{target_file_path}`
    params = { count_word: true }
    assert_output(expected) { puts count_files([target_file_path], params) }
  end

  def test_count_words_in_stdin
    text = 'RuboCop is a Ruby static code analyzer (a.k.a. linter) and code formatter. Out of the box it will enforce many of the guidelines outlined in the community Ruby Style Guide.'
    stdin = "<<EOS
    #{text}
EOS\n"
    expected = `wc -w #{stdin}`
    $stdin = StringIO.new(text)
    params = { count_word: true }
    assert_output(expected) { puts count_stdin($stdin, params) }
  end
end
