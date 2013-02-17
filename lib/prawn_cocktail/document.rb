require "prawn"
require "active_support/core_ext/class/attribute"

require_relative "renderer"

module PrawnCocktail
  class Document
    def render
      renderer.render_data
    end

    def render_file(file)
      renderer.render_file(file)
    end

    private

    def renderer
      @renderer ||= Renderer.new(template, data, self.class.doc_initializers)
    end

    def template
      self.class.name.underscore
    end

    class_attribute :doc_initializers
    self.doc_initializers ||= []

    def self.initialize_document(&block)
      self.doc_initializers << block
    end

    def self.helper(mod)
      initialize_document { extend mod }
    end
  end
end
