require "prawn_cocktail/version"
require "prawn_cocktail/controller"
require "prawn_cocktail/document"
require "prawn_cocktail/railtie"

class ActionController::Base
  include PrawnCocktail::Controller
end
