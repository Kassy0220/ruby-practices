# frozen_string_literal: true

# 与えられたファイル名を、表示用に整形するクラス
class ShortFormatter
  def initialize(paths)
    @paths = paths
    @number_of_columns = 3
  end

  def format
    transposed_paths = transpose_path
    column_width = calc_column_width

    transposed_paths.map { |row| concat_row(row, column_width) }.join("\n")
  end

  private

  def transpose_path
    number_of_rows = (@paths.length.to_f / @number_of_columns).ceil
    # transpose を使うので、配列内の要素数が揃うように空白を追加する
    paths = @paths
    paths << '' while paths.length < @number_of_columns * number_of_rows
    paths.each_slice(number_of_rows).to_a.transpose
  end

  def calc_column_width
    # 非ascii文字は、表示幅をプラス1でカウントする
    @paths.map { |path| path.length + path.chars.count { |char| !char.ascii_only? } }.max + 5
  end

  def concat_row(row, column_width)
    row.map { |path| path.ascii_only? ? path.ljust(column_width) : ljust_not_ascii(path, column_width) }.join.rstrip
  end

  def ljust_not_ascii(path, column_width)
    not_ascii_chars = path.chars.count { |char| !char.ascii_only? }
    path.ljust(column_width - not_ascii_chars)
  end
end
