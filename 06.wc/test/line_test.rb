# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require_relative '../lib/wc'

class LineTest < Minitest::Test
  def test_count_lines_in_a_file
    target_file_path = 'test/fixtures/sample.txt'
    expected = `wc -l #{target_file_path}`
    params = { count_line: true }
    assert_output(expected) { puts count_files([target_file_path], params) }
  end

  def test_count_lines_in_two_files
    first_target_file_path = 'test/fixtures/sample.txt'
    second_target_file_path = 'test/fixtures/second_sample.txt'
    expected = `wc -l #{first_target_file_path} #{second_target_file_path}`
    params = { count_line: true }
    assert_output(expected) { puts count_files([first_target_file_path, second_target_file_path], params) }
  end

  def test_count_lines_in_empty_file
    target_file_path = 'test/fixtures/empty.txt'
    expected = `wc -l #{target_file_path}`
    params = { count_line: true }
    assert_output(expected) { puts count_files([target_file_path], params) }
  end

  def test_count_lines_in_stdin
    stdin = "<<EOS
hoge
fuga
piyo
EOS\n"
    expected = `wc -l #{stdin}`
    $stdin = StringIO.new("hoge\nfuga\npiyo\n")
    params = { count_line: true }
    assert_output(expected) { puts count_stdin(params) }
  end 
end
