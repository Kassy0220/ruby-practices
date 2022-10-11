# frozen_string_literal: true

require_relative 'builder'
require_relative 'content'

# Builderで用意されているメソッドを実行して、ディレクトリの中身を取得するクラス
class List
  def self.list(path, options)
    new(path, options).list
  end

  def initialize(path, options)
    @builder = Builder.new(path, options)
  end

  def list
    @builder.collect_path
    @builder.format
    @builder.result
  end
end
