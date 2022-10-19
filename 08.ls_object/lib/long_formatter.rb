# frozen_string_literal: true

require 'etc'
require_relative 'filemode'

# 与えられたファイル名を、ファイル情報を付加した長い形式で表示用に整形するクラス
class LongFormatter
  def initialize(searched_path, paths)
    @searched_path = searched_path
    @paths = paths
  end

  def format
    file_statuses = @paths.map { |path| file_status(path) }
    max_sizes = count_max_characters(file_statuses)
    format_status(file_statuses, max_sizes)
  end

  private

  def file_status(file)
    status = directory? ? File.lstat("#{@searched_path}/#{file}") : File.lstat(@searched_path)
    mode = FileMode.new(status.mode.to_s(8).rjust(6, '0'))
    filetype = mode.filetype
    permission = mode.file_permission
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
    @paths.map { |path| File.lstat("#{@searched_path}/#{path}").blocks }.sum
  end

  def directory?
    File.directory?(@searched_path)
  end
end
