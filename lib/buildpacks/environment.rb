module Buildpacks
  class Environment
    def formulas
      formula_path = File.join(File.dirname(__FILE__), 'formulas')

      @formulas ||= Dir[File.join(formula_path, '**', '*.rb')].collect do |formula|
        eval(File.read(formula), binding)
      end
    end

    def find_formula(name)
      formulas.find { |formula| formula.name == name }
    end

    private

    def formula(name, &block)
      formula = Formula.new(name.to_s, self, &block)
      formula.instance_eval(&block)
      formula
    end
  end
end
