# frozen_string_literal: true

require 'etc'
require_relative 'filetype'
require_relative 'filepermission'

# ファイルの中身の取得処理と、表示用に整形する処理を実装したクラス
class Builder
  include FileType
  include FilePermission

  def initialize(path, options)
    @content = Content.new
    @searched_path = path
    @options = options
    @number_of_columns = 3
  end

  def result
    @content.formatted_paths
  end

  def collect_path
    return @content.paths = [File.basename(@searched_path)] unless directory?

    flag = @options[:dot_match] ? File::FNM_DOTMATCH : 0
    paths = Dir.glob('*', flag, base: @searched_path).sort
    @content.paths = @options[:reverse] ? paths.reverse : paths
  end

  def format
    @options[:long_format] ? long_format : short_format
  end

  private

  def long_format
    file_statuses = @content.paths.map { |path| file_status(path) }
    max_sizes = count_max_characters(file_statuses)
    @content.formatted_paths = format_status(file_statuses, max_sizes)
  end

  def file_status(file)
    status = directory? ? File.lstat("#{@searched_path}/#{file}") : File.lstat(@searched_path)
    mode = status.mode.to_s(8).rjust(6, '0')
    filetype = filetype(mode[0..1])
    permission = format_permission(mode[2..5])
    symlink = " -> #{File.readlink("#{@searched_path}/#{file}")}" if filetype == 'l'
    {
      type_and_permission: "#{filetype}#{permission}",
      links: status.nlink.to_s,
      uname: Etc.getpwuid(status.uid).name,
      grpname: Etc.getgrgid(status.gid).name,
      size: status.size.to_s,
      datetime: status.mtime.strftime('%_m %e %R'),
      filename: "#{file}#{symlink}"
    }
  end

  def count_max_characters(file_statuses)
    status_items = %i[links uname grpname size]
    max_characters = status_items.map do |item|
      { item => file_statuses.map { |file_status| file_status[item].size }.max }
    end
    # 配列内にハッシュが4つ存在しているので、それを1つに結合する
    max_characters.inject { |result, hash| result.merge hash }
  end

  def format_status(file_statuses, max_sizes)
    formatted_statuses = file_statuses.map do |file_status|
      [
        file_status[:type_and_permission],
        "  #{file_status[:links].rjust(max_sizes[:links])}",
        " #{file_status[:uname].ljust(max_sizes[:uname])}",
        "  #{file_status[:grpname].ljust(max_sizes[:grpname])}",
        "  #{file_status[:size].rjust(max_sizes[:size])}",
        " #{file_status[:datetime]}",
        " #{file_status[:filename]}"
      ].join
    end
    directory? ? ["total #{sum_file_blocks}", formatted_statuses].join("\n") : formatted_statuses[0]
  end

  def sum_file_blocks
    @content.paths.map { |path| File.lstat("#{@searched_path}/#{path}").blocks }.sum
  end

  def directory?
    File.directory?(@searched_path)
  end

  def short_format
    transposed_paths = transpose_path
    column_width = column_width(@content.paths)

    @content.formatted_paths = transposed_paths.map { |row| concat_row(row, column_width) }.join("\n")
  end

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
