# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require_relative '../lib/wc'

class MultipleOptionsTest < Minitest::Test
  # 引数にファイルを1つ指定した時のテスト
  def test_count_a_file_with_lwc_options
    target_file_path = 'test/fixtures/sample.txt'
    params = { count_line: true, count_word: true, count_byte: true }
    expected = `wc -lwc #{target_file_path}`
    assert_output(expected) { puts count_files([target_file_path], params) }
  end

  def test_count_a_file_with_lw_options
    target_file_path = 'test/fixtures/sample.txt'
    params = { count_line: true, count_word: true }
    expected = `wc -lw #{target_file_path}`
    assert_output(expected) { puts count_files([target_file_path], params) }
  end

  def test_count_a_file_with_lc_options
    target_file_path = 'test/fixtures/sample.txt'
    params = { count_line: true, count_byte: true }
    expected = `wc -lc #{target_file_path}`
    assert_output(expected) { puts count_files([target_file_path], params) }
  end

  def test_count_a_file_with_wc_options
    target_file_path = 'test/fixtures/sample.txt'
    params = { count_word: true, count_byte: true }
    expected = `wc -wc #{target_file_path}`
    assert_output(expected) { puts count_files([target_file_path], params) }
  end

  # 引数にファイルを2つ指定した時のテスト
  def test_count_two_files_with_lw_options
    first_target_file_path = 'test/fixtures/sample.txt'
    second_target_file_path = 'test/fixtures/second_sample.txt'
    params = { count_line: true, count_word: true }
    expected = `wc -lw #{first_target_file_path} #{second_target_file_path}`
    assert_output(expected) { puts count_files([first_target_file_path, second_target_file_path], params) }
  end

  def test_count_stdin_with_lw_options
    stdin = "<<EOS
              London Bridge is falling down
              Falling down, falling down
              London Bridge is falling down
              Myfiar lady
EOS\n"
    expected = `wc -lw #{stdin}`
    text = "London Bridge is falling down\nFalling down, falling down\nLondon Bridge is falling down\nMyfiar lady\n"
    $stdin = StringIO.new(text)
    params = { count_line: true, count_word: true }
    assert_output(expected) { puts count_stdin($stdin, params) }
  end
end
