# frozen_string_literal: true

require_relative 'short_formatter'
require_relative 'long_formatter'

# ファイルの中身の取得処理と、表示用に整形する処理を実装したクラス
class Builder
  include FileType
  include FilePermission

  attr_writer :collected_paths

  def initialize(path, options)
    @searched_path = path
    @options = options
  end

  def collect_path
    return @collected_paths = [File.basename(@searched_path)] unless directory?

    flag = @options[:dot_match] ? File::FNM_DOTMATCH : 0
    paths = Dir.glob('*', flag, base: @searched_path).sort
    @collected_paths = @options[:reverse] ? paths.reverse : paths
  end

  def result
    formatter = @options[:long_format] ? LongFormatter.new(@searched_path, @collected_paths) : ShortFormatter.new(@collected_paths)
    formatter.format
  end

  private

  def directory?
    File.directory?(@searched_path)
  end
end
