module PrawnCocktail
  class Renderer
    def initialize(template, data, doc_initializers)
      @template = template
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
      # We pass the filename for better backtraces.
      instance_eval(read_template, template_path)
    end

    def doc
      @doc ||= Prawn::Document.new(@prawn_document_options || {})
    end

    def data_object
      OpenStruct.new(@data)
    end

    def read_template
      File.read(File.join(app_root, template_path))
    end

    def template_path
      "app/views/documents/#{@template}.pdf.rb"
    end

    def app_root
      Rails.root
    end
  end
end
