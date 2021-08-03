require "active_support/core_ext/class/attribute"
require "active_support/inflector"
require_relative "renderer"

module PrawnCocktail
  class Document
    class_attribute :initializers
    self.initializers = []

    def self.initialize_template(&block)
      self.initializers += [ block ]
    end

    def self.helper(mod)
      initialize_template { extend mod }
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
      @renderer ||= Renderer.new(template_name, data, initializers)
    end

    def template_name
      self.class.name.underscore
    end

    def data
      # Override in your subclass.
      {}
    end

    def initializers
      self.class.initializers
    end
  end
end
