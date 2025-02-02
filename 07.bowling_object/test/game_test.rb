# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/game'
require_relative '../lib/frame'
require_relative '../lib/shot'

class GameTest < Minitest::Test
  def setup
    @game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    @frames = @game.to_frame
  end

  def test_to_frame
    # 第1フレームのテスト
    first_frame = @game.find_frame(@frames, 1)
    assert_equal 6, first_frame.first_shot.pins
    assert_equal 3, first_frame.second_shot.pins
    assert_equal 0, first_frame.third_shot.pins

    # 第6フレーム(ストライク)のテスト
    sixth_frame = @game.find_frame(@frames, 6)
    assert_equal 10, sixth_frame.first_shot.pins
    assert_equal 0, sixth_frame.second_shot.pins
    assert_equal 0, sixth_frame.third_shot.pins

    # 第10フレームのテスト
    tenth_frame = @game.find_frame(@frames, 10)
    assert_equal 6, tenth_frame.first_shot.pins
    assert_equal 4, tenth_frame.second_shot.pins
    assert_equal 5, tenth_frame.third_shot.pins
  end

  def test_total_pins
    assert_equal 94, @game.total_pins(@frames)
  end

  def test_bonus_score
    assert_equal 45, @game.bonus_score(@frames)
  end

  def test_score
    assert_equal 139, @game.score

    game_with_two_shots_in_tenth_frame = Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
    assert_equal 107, game_with_two_shots_in_tenth_frame.score

    prefect_game = Game.new('X,X,X,X,X,X,X,X,X,X,X,X')
    assert_equal 300, prefect_game.score
  end
end
