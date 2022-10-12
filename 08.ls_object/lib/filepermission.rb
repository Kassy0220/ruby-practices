# frozen_string_literal: true

# ファイルのパーミッションを返すメソッドを提供するモジュール
module FilePermission
  def format_permission(mode)
    # 引数 mode は4文字の数字
    # 先頭の数字は特殊権限を、2-4番目の数字はそれぞれ所有者、所有グループ、その他に対する権限を表す
    special_permission = special_permission(mode[0])
    permission = mode[1..3].chars.map { |char| permission(char) }.join
    return permission if special_permission == 'none'

    case special_permission
    when 'stickybit'
      permission[8] = permission[8] == 'x' ? 't' : 'T'
    when 'sgid'
      permission[5] = permission[5] == 'x' ? 's' : 'S'
    when 'suid'
      permission[2] = permission[2] == 'x' ? 's' : 'S'
    end
    permission
  end

  def permission(permission)
    {
      '0' => '---',
      '1' => '--x',
      '2' => '-w-',
      '3' => '-wx',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }[permission]
  end

  def special_permission(permission)
    {
      '0' => 'none',
      '1' => 'stickybit',
      '2' => 'sgid',
      '4' => 'suid'
    }[permission]
  end
end
