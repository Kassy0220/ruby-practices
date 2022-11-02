# frozen_string_literal: true

class FileMode
  def initialize(mode_integer)
    @filetype_integer = mode_integer[0..1]
    @permission_integer = mode_integer[2..5]
  end

  def filetype
    {
      '01' => 'p',
      '02' => 'c',
      '04' => 'd',
      '06' => 'b',
      '10' => '-',
      '12' => 'l',
      '14' => 's'
    }[@filetype_integer]
  end

  def file_permission
    permission = @permission_integer[1..3].chars.map { |char| permission(char) }.join
    special_permission = special_permission(@permission_integer[0])
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

  private

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
