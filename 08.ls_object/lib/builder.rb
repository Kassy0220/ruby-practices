# frozen_string_literal: true

# ファイルの中身の取得処理と、表示用に整形する処理を実装したクラス
class Builder
  def initialize(path)
    @content = Content.new
    @searched_path = path
    @number_of_columns = 3
  end

  def result
    @content.formatted_paths
  end

  def collect_path
    return @content.paths = [File.basename(@searched_path)] unless File.directory?(@searched_path)

    @content.paths = Dir.glob('*', base: @searched_path).sort
  end

  def format
    transposed_paths = transpose_path
    column_width = column_width(@content.paths)

    @content.formatted_paths = transposed_paths.map { |row| concat_row(row, column_width) }.join("\n")
  end

  private

  def transpose_path
    number_of_rows = (@content.paths.length.to_f / @number_of_columns).ceil
    # transpose を使うので、配列内の要素数が揃うように空白を追加する
    @content.paths << '' while @content.paths.length < @number_of_columns * number_of_rows
    @content.paths.each_slice(number_of_rows).to_a.transpose
  end

  def column_width(paths)
    # 非ascii文字は、表示幅をプラス1でカウントする
    paths.map { |path| path.length + path.chars.count { |char| !char.ascii_only? } }.max + 5
  end

  def concat_row(row, column_width)
    row.map { |path| path.ascii_only? ? path.ljust(column_width) : ljust_not_ascii(path, column_width) }.join.rstrip
  end

  def ljust_not_ascii(path, column_width)
    not_ascii_chars = path.chars.count { |char| !char.ascii_only? }
    path.ljust(column_width - not_ascii_chars)
  end
end
