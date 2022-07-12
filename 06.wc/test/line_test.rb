# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require_relative '../lib/wc'

class LineTest < Minitest::Test
  TARGET_PATH = 'test/fixtures/sample.txt'
  SECOND_TARGET_PATH = 'test/fixtures/second_sample.txt'
  EMPTY_TARGET_PATH = 'test/fixtures/empty.txt'
  HEREDOCUMENT = "<<EOS
hoge
fuga
piyo
EOS\n"
  TEXT = "hoge\nfuga\npiyo\n"

  def test_count_lines_in_a_file
    expected = `wc -l #{TARGET_PATH}`
    params = { count_line: true }
    assert_output(expected) { puts count_files([TARGET_PATH], params) }
  end

  def test_count_lines_in_two_files
    expected = `wc -l #{TARGET_PATH} #{SECOND_TARGET_PATH}`
    params = { count_line: true }
    assert_output(expected) { puts count_files([TARGET_PATH, SECOND_TARGET_PATH], params) }
  end

  def test_count_lines_in_empty_file
    expected = `wc -l #{EMPTY_TARGET_PATH}`
    params = { count_line: true }
    assert_output(expected) { puts count_files([EMPTY_TARGET_PATH], params) }
  end

  def test_count_lines_in_stdin
    expected = `wc -l #{HEREDOCUMENT}`
    $stdin = StringIO.new(TEXT)
    params = { count_line: true }
    assert_output(expected) { puts count_stdin(params) }
  end
end
