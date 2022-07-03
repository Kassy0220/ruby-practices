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
end
