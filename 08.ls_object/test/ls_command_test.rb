# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/list_command'

class LsCommandTest < Minitest::Test
  def test_ls_without_options
    expected = <<~TEXT.chomp
      01.fizzbuzz           05.ls                 09.wc_object
      02.calendar           06.wc                 README.md
      03.rake               07.bowling_object
      04.bowling            08.ls_object
    TEXT
    assert_equal expected, ListCommand.list_paths('../', {})
  end

  def test_not_ascii_filename
    expected = <<~TEXT.chomp
      Bayonetta2              Pokemonアルセウス       ゼルダの伝説
      FF                      どうぶつの森            ドンキーコング
      GAME&WATCH              カービィ                ピクミン
      MOTHER                  スプラトゥーン          ポケモン
      Metroid                 スマブラX               マリオカート
      Newポケモンスナップ     ゼノブレイド3
    TEXT
    assert_equal expected, ListCommand.list_paths('./test/fixtures/ls_sample_directory', {})
  end

  def test_search_file
    expected = <<~TEXT.chomp
      ls.rb
    TEXT
    assert_equal expected, ListCommand.list_paths('./bin/ls.rb', {})
  end

  def test_with_a_option
    expected = <<~TEXT.chomp
      .                     01.fizzbuzz           06.wc
      .DS_Store             02.calendar           07.bowling_object
      .git                  03.rake               08.ls_object
      .gitignore            04.bowling            09.wc_object
      .rubocop.yml          05.ls                 README.md
    TEXT
    assert_equal expected, ListCommand.list_paths('../', { dot_match: true })
  end

  def test_with_r_option
    expected = <<~TEXT.chomp
      README.md             06.wc                 02.calendar
      09.wc_object          05.ls                 01.fizzbuzz
      08.ls_object          04.bowling
      07.bowling_object     03.rake
    TEXT
    assert_equal expected, ListCommand.list_paths('../', { reverse: true })
  end

  def test_with_l_option
    expected = <<~TEXT.chomp
      total 0
      prw-r--r--  1 kashiyama  staff   0 10 10 14:49 fifo
      -rw-r--r--  1 kashiyama  staff   0 10 10 14:49 sample.txt
      drwxr-xr-x  2 kashiyama  staff  64 10 10 14:49 sample_directory
      -rwxr-sr-x  1 kashiyama  staff   0 10 10 14:49 sgid
      -rwxr-Sr-x  1 kashiyama  staff   0 10 10 14:49 sgid_without_x
      drwxr-xr-t  2 kashiyama  staff  64 10 10 14:49 stickybit
      drwxr-xr-T  2 kashiyama  staff  64 10 10 14:49 stickybit_without_x
      -rwsr-xr-x  1 kashiyama  staff   0 10 10 14:49 suid
      -rwSr-xr-x  1 kashiyama  staff   0 10 10 14:49 suid_without_x
      lrwxr-xr-x  1 kashiyama  staff  10 10 10 15:06 symbolic_link -> sample.txt
    TEXT
    assert_equal expected, ListCommand.list_paths('./test/fixtures/ls_sample_longformat', { long_format: true })
  end

  def test_search_file_with_l_option
    expected = <<~TEXT.chomp
      -rw-r--r--  1 kashiyama  staff  2648  5 13 08:47 README.md
    TEXT
    assert_equal expected, ListCommand.list_paths('../README.md', { long_format: true })
  end

  def test_with_all_options
    expected = <<~TEXT.chomp
      total 0
      lrwxr-xr-x   1 kashiyama  staff   10 10 10 15:06 symbolic_link -> sample.txt
      -rwSr-xr-x   1 kashiyama  staff    0 10 10 14:49 suid_without_x
      -rwsr-xr-x   1 kashiyama  staff    0 10 10 14:49 suid
      drwxr-xr-T   2 kashiyama  staff   64 10 10 14:49 stickybit_without_x
      drwxr-xr-t   2 kashiyama  staff   64 10 10 14:49 stickybit
      -rwxr-Sr-x   1 kashiyama  staff    0 10 10 14:49 sgid_without_x
      -rwxr-sr-x   1 kashiyama  staff    0 10 10 14:49 sgid
      drwxr-xr-x   2 kashiyama  staff   64 10 10 14:49 sample_directory
      -rw-r--r--   1 kashiyama  staff    0 10 10 14:49 sample.txt
      prw-r--r--   1 kashiyama  staff    0 10 10 14:49 fifo
      drwxr-xr-x  12 kashiyama  staff  384 10 10 15:06 .
    TEXT
    assert_equal expected, ListCommand.list_paths('./test/fixtures/ls_sample_longformat', { dot_match: true, reverse: true, long_format: true })
  end
end
