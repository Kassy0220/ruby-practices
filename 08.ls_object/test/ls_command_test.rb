# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/list'

class LsCommandTest < Minitest::Test
  def test_ls_without_options
    expected = <<~TEXT.chomp
      01.fizzbuzz           05.ls                 09.wc_object
      02.calendar           06.wc                 README.md
      03.rake               07.bowling_object
      04.bowling            08.ls_object
    TEXT
    assert_equal expected, List.list('../', {})
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
    assert_equal expected, List.list('./test/fixtures/ls_sample_directory', {})
  end

  def test_search_file
    expected = <<~TEXT.chomp
      ls.rb
    TEXT
    assert_equal expected, List.list('./bin/ls.rb', {})
  end

  def test_with_a_option
    expected = <<~TEXT.chomp
      .                     01.fizzbuzz           06.wc
      .DS_Store             02.calendar           07.bowling_object
      .git                  03.rake               08.ls_object
      .gitignore            04.bowling            09.wc_object
      .rubocop.yml          05.ls                 README.md
    TEXT
    assert_equal expected, List.list('../', { dot_match: true })
  end
end
