require 'buildpacks/helpers'

module Buildpacks
  class Which < Struct.new(:binary)
    def exist?
      `which #{binary}`.chomp != ''
    end
  end

  class Detect < Struct.new(:definition)
    def which(binary)
      Which.new(binary)
    end

    def call
      instance_eval(&definition)
    end
  end

  class Compile < Struct.new(:definition)
    def add_to_path

    end

    def run

    end

    def call
      instance_eval(&definition)
    end
  end

  class Formula
    extend AttrBlock
    extend AttrSplat

    attr_block :detect, :compile
    attr_splat :depends_on
    attr_reader :name

    def initialize(name, env, &block)
      @name = name
      @env = env
      @depends_on = []
    end

    def detected?
      Detect.new(@detect_block).call
    end

    def compile!
      @depends_on.each { |name| @env.find_formula(name).compile! }
      Compile.new(@compile_block).call
    end
  end
end
