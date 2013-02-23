module PrawnCocktail
  class << self
    attr_accessor :template_root
  end

  # Defaults.

  self.template_root = "app/views/documents"
end
