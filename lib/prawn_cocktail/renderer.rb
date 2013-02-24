require_relative "template"

module PrawnCocktail
  class Renderer
    def initialize(template_name, data, initializers)
      @template_name = template_name
      @data = data
      @initializers = initializers
    end

    def meta(opts)
      @prawn_document_options = opts
    end

    def content(&block)
      @initializers.each do |proc|
        prawn_document.instance_eval(&proc)
      end

      prawn_document.instance_exec(data_object, &block)
    end

    def render_data
      apply_template
      prawn_document.render
    end

    def render_file(file)
      apply_template
      prawn_document.render_file(file)
    end

    private

    def apply_template
      Template.new(@template_name).apply(self)
    end

    def prawn_document
      @doc ||= Prawn::Document.new(@prawn_document_options || {})
    end

    def data_object
      OpenStruct.new(@data)
    end
  end
end
