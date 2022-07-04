# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require_relative '../lib/wc'

class MultipleOptionsTest < Minitest::Test
  TARGET_PATH = 'test/fixtures/sample.txt'
  SECOND_TARGET_PATH = 'test/fixtures/second_sample.txt'
  HEREDOCUMENT = "<<EOS
London Bridge is falling down
Falling down, falling down
London Bridge is falling down
My fair lady
EOS\n"
  TEXT = "London Bridge is falling down\nFalling down, falling down\nLondon Bridge is falling down\nMy fair lady\n"

  # 引数にファイルを1つ指定した時のテスト
  def test_count_a_file_with_lwc_options
    params = { count_line: true, count_word: true, count_byte: true }
    expected = `wc -lwc #{TARGET_PATH}`
    assert_output(expected) { puts count_files([TARGET_PATH], params) }
  end

  def test_count_a_file_with_lw_options
    params = { count_line: true, count_word: true }
    expected = `wc -lw #{TARGET_PATH}`
    assert_output(expected) { puts count_files([TARGET_PATH], params) }
  end

  def test_count_a_file_with_lc_options
    params = { count_line: true, count_byte: true }
    expected = `wc -lc #{TARGET_PATH}`
    assert_output(expected) { puts count_files([TARGET_PATH], params) }
  end

  def test_count_a_file_with_wc_options
    params = { count_word: true, count_byte: true }
    expected = `wc -wc #{TARGET_PATH}`
    assert_output(expected) { puts count_files([TARGET_PATH], params) }
  end

  # 引数にファイルを2つ指定した時のテスト
  def test_count_two_files_with_lwc_options
    params = { count_line: true, count_word: true, count_byte: true }
    expected = `wc -lwc #{TARGET_PATH} #{SECOND_TARGET_PATH}`
    assert_output(expected) { puts count_files([TARGET_PATH, SECOND_TARGET_PATH], params) }
  end

  def test_count_two_files_with_lw_options
    params = { count_line: true, count_word: true }
    expected = `wc -lw #{TARGET_PATH} #{SECOND_TARGET_PATH}`
    assert_output(expected) { puts count_files([TARGET_PATH, SECOND_TARGET_PATH], params) }
  end

  def test_count_two_files_with_lc_options
    params = { count_line: true, count_byte: true }
    expected = `wc -lc #{TARGET_PATH} #{SECOND_TARGET_PATH}`
    assert_output(expected) { puts count_files([TARGET_PATH, SECOND_TARGET_PATH], params) }
  end

  def test_count_two_files_with_wc_options
    params = { count_word: true, count_byte: true }
    expected = `wc -wc #{TARGET_PATH} #{SECOND_TARGET_PATH}`
    assert_output(expected) { puts count_files([TARGET_PATH, SECOND_TARGET_PATH], params) }
  end

  # 標準入力をカウントするテスト
  def test_count_stdin_with_lwc_options
    expected = `wc -lwc #{HEREDOCUMENT}`
    $stdin = StringIO.new(TEXT)
    params = { count_line: true, count_word: true, count_byte: true }
    assert_output(expected) { puts count_stdin(params) }
  end

  def test_count_stdin_with_lw_options
    expected = `wc -lw #{HEREDOCUMENT}`
    $stdin = StringIO.new(TEXT)
    params = { count_line: true, count_word: true }
    assert_output(expected) { puts count_stdin(params) }
  end

  def test_count_stdin_with_lc_options
    expected = `wc -lc #{HEREDOCUMENT}`
    $stdin = StringIO.new(TEXT)
    params = { count_line: true, count_byte: true }
    assert_output(expected) { puts count_stdin(params) }
  end

  def test_count_stdin_with_wc_options
    expected = `wc -wc #{HEREDOCUMENT}`
    $stdin = StringIO.new(TEXT)
    params = { count_word: true, count_byte: true }
    assert_output(expected) { puts count_stdin(params) }
  end
end
