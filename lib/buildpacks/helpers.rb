module Buildpacks
  module AttrBlock
    def attr_block(*names)
      names.each do |name|
        define_method(name) do |&block|
          instance_variable_set("@#{name}_block", block)
        end
      end
    end
  end

  module AttrSplat
    def attr_splat(*names)
      names.each do |name|
        define_method(name) do |*values|
          var = instance_variable_get("@#{name}")
          var ||= []
          var += values
          instance_variable_set("@#{name}", var)
        end
      end
    end
  end

end
