# frozen_string_literal: true

require_relative '../lib/list'
require_relative '../lib/builder'
require_relative '../lib/content'

searched_path = ARGV[0] || '.'
puts List.list(searched_path)
