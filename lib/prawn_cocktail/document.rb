require "prawn"
require "active_support/core_ext/class/attribute"
require "active_support/inflector"

require_relative "renderer"

module PrawnCocktail
  class Document
    class_attribute :doc_initializers
    self.doc_initializers = []

    def self.initialize_document(&block)
      self.doc_initializers += [block]
    end

    def self.helper(mod)
      initialize_document { extend mod }
    end

    def render
      renderer.render_data
    end

    def render_file(file)
      renderer.render_file(file)
    end

    def filename
      # Override in your subclass.
      nil
    end

    private

    def renderer
      @renderer ||= Renderer.new(template_name, data, self.class.doc_initializers)
    end

    def template_name
      self.class.name.underscore
    end

    def data
      # Override in your subclass.
      {}
    end
  end
end
