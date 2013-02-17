module PrawnCocktail
  module Controller
    private

    def send_pdf(document)
      filename = document.respond_to?(:filename) ? "#{document.filename}.pdf" : nil

      send_data(
        document.render,
        type: "application/pdf",
        disposition: "attachment",
        filename: filename
      )
    end
  end
end
