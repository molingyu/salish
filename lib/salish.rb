#encoding: utf-8
#author: shitake
#data: 16-3-26

require '../lib/salish/version'
require '../lib/salish/command'
require '../lib/salish/help'

module Salish

  class << self
    def version_str?(ver_str)
      /\d*\.\d*\.\d*/ === ver_str
    end

    def cmd
      Command.new
    end

    def error(error_code)
      Error.new(error_code)
    end

  end

end