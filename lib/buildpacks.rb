require 'buildpacks/environment'
require 'buildpacks/fetch'
require 'buildpacks/formula'
require 'buildpacks/version'

module Buildpacks
  attr_accessor :formulas

  def self.detect?(path)
    return false unless Dir.exists?(path)

    Dir.chdir(path) do
      Environment.new.formulas.find(&:detected?)
    end
  end
end


