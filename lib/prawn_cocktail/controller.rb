module PrawnCocktail
  module Controller
    private

    def send_pdf(document)
      send_data(
        document.render,
        type: "application/pdf",
        disposition: "attachment",
        filename: document.filename
      )
    end
  end
end
