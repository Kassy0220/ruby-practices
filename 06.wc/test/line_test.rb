require 'minitest/autorun'
require_relative '../lib/wc'

class LineTest < Minitest::Test
  def test_a_file_lines
    target_file_path = 'test/fixtures/sample.txt'
    expected = `wc -l #{target_file_path}`.chomp
    assert_equal expected, main([target_file_path])
  end

  def test_two_files_lines
    first_target_file_path = 'test/fixtures/sample.txt'
    second_target_file_path = 'test/fixtures/second_sample.txt'
    expected = `wc -l #{first_target_file_path} #{second_target_file_path}`.chomp
    assert_equal expected, main([first_target_file_path, second_target_file_path])
  end

  def test_empty_file
    target_file_path = 'test/fixtures/empty.txt'
    expected = `wc -l #{target_file_path}`.chomp
    assert_equal expected, main([target_file_path])
  end

  def test_stdin_lines

  end
end
