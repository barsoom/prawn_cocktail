require_relative "template"

module PrawnCocktail
  class Renderer
    def initialize(template_name, data, doc_initializers)
      @template_name = template_name
      @data = data
      @doc_initializers = doc_initializers
    end

    def meta(opts)
      @prawn_document_options = opts
    end

    def content(&block)
      @doc_initializers.each do |proc|
        doc.instance_eval(&proc)
      end

      doc.instance_exec(data_object, &block)
    end

    def render_data
      render
      doc.render
    end

    def render_file(file)
      render
      doc.render_file(file)
    end

    private

    def render
      Template.new(@template_name).render(self)
    end

    def doc
      @doc ||= Prawn::Document.new(@prawn_document_options || {})
    end

    def data_object
      OpenStruct.new(@data)
    end
  end
end
