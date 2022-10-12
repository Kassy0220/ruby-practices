# frozen_string_literal: true

# ファイルのタイプを判別するメソッドを提供するモジュール
module FileType
  def filetype(filetype)
    {
      '01' => 'p',
      '02' => 'c',
      '04' => 'd',
      '06' => 'b',
      '10' => '-',
      '12' => 'l',
      '14' => 's'
    }[filetype]
  end
end
