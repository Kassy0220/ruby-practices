# frozen_string_literal: true

require_relative 'builder'

# Builderで用意されているメソッドを実行して、ディレクトリの中身を取得するクラス
class ListCommand
  def self.list_paths(path, options)
    new(path, options).list_paths
  end

  def initialize(path, options)
    @builder = Builder.new(path, options)
  end

  def list_paths
    @builder.collect_path
    @builder.result
  end
end
