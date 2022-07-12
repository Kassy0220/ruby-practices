# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require_relative '../lib/wc'

class WordTest < Minitest::Test
  TARGET_PATH = 'test/fixtures/sample.txt'
  SECOND_TARGET_PATH = 'test/fixtures/second_sample.txt'
  EMPTY_TARGET_PATH = 'test/fixtures/empty.txt'
  HEREDOCUMENT = "<<EOS
RuboCop is a Ruby static code analyzer (a.k.a. linter) and code formatter.
EOS\n"
  TEXT = "RuboCop is a Ruby static code analyzer (a.k.a. linter) and code formatter.\n"

  def test_count_words_in_a_file
    expected = `wc -w #{TARGET_PATH}`
    params = { count_word: true }
    assert_output(expected) { puts count_files([TARGET_PATH], params) }
  end

  def test_count_words_in_two_files
    expected = `wc -w #{TARGET_PATH} #{SECOND_TARGET_PATH}`
    params = { count_word: true }
    assert_output(expected) { puts count_files([TARGET_PATH, SECOND_TARGET_PATH], params) }
  end

  def test_count_words_in_empty_file
    expected = `wc -w #{EMPTY_TARGET_PATH}`
    params = { count_word: true }
    assert_output(expected) { puts count_files([EMPTY_TARGET_PATH], params) }
  end

  def test_count_words_in_stdin
    expected = `wc -w #{HEREDOCUMENT}`
    $stdin = StringIO.new(TEXT)
    params = { count_word: true }
    assert_output(expected) { puts count_stdin(params) }
  end
end
