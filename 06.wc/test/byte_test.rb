# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require_relative '../lib/wc'

class ByteTest < Minitest::Test
  def test_count_bytes_in_a_file
    target_file_path = 'test/fixtures/sample.txt'
    expected = `wc -c #{target_file_path}`
    params = { count_byte: true }
    assert_output(expected) { puts count_files([target_file_path], params) }
  end

  def test_count_bytes_in_empty_file
    target_file_path = 'test/fixtures/empty.txt'
    expected = `wc -c #{target_file_path}`
    params = { count_byte: true }
    assert_output(expected) { puts count_files([target_file_path], params) }
  end

  def test_count_words_in_two_files
    first_target_file_path = 'test/fixtures/sample.txt'
    second_target_file_path = 'test/fixtures/second_sample.txt'
    expected = `wc -c #{first_target_file_path} #{second_target_file_path}`
    params = { count_byte: true }
    assert_output(expected) { puts count_files([first_target_file_path, second_target_file_path], params) }
  end

  def test_count_bytes_in_stdin
    stdin = "<<EOS
RuboCop is a Ruby static code analyzer (a.k.a. linter) and code formatter.
EOS\n"
    expected = `wc -c #{stdin}`
    text = "RuboCop is a Ruby static code analyzer (a.k.a. linter) and code formatter.\n"
    $stdin = StringIO.new(text)
    params = { count_byte: true }
    assert_output(expected) { puts count_stdin($stdin, params) }
  end
end
