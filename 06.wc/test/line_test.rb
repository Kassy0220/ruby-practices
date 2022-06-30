require 'minitest/autorun'
require_relative '../lib/wc'

class LineTest < Minitest::Test
  def test_a_file_lines
    target_file_path = 'test/fixtures/sample.txt'
    expected = `wc -l #{target_file_path}`
    assert_equal expected, main(target_file_path)
  end

  def test_two_files_lines

  end

  def test_stdin_lines

  end
end
