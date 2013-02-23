module PrawnCocktail
  class Template
    def initialize(name)
      @name = name
    end

    def apply(context)
      context.instance_eval(read_template, template_path)
    end

    private

    def read_template
      File.read(template_path)
    end

    def template_path
      File.join(template_root, "#{@name}.pdf.rb")
    end

    def template_root
      PrawnCocktail.template_root
    end
  end
end
