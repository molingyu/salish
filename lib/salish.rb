#encoding: utf-8
#author: shitake
#data: 16-3-26

module Salish
  require 'salish/help'
  require 'salish/version'
  require 'salish/command'
  class << self

    def version_str?(ver_str)
      /\d*\.\d*\.\d*/ === ver_str
    end

  end

end