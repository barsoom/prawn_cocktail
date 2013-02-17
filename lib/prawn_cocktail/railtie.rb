require "rails"

module PrawnCocktail
  class Railtie < Rails::Railtie
    initializer "prawn_cocktail.autoload", before: :set_autoload_paths do |app|
      app.config.autoload_paths << "#{app.config.root}/app/documents/helpers"
    end
  end
end
