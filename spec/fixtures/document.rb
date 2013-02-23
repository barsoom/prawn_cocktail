module TestDocumentHelper
  def status_line(status)
    text "Status: #{status}"
  end
end

class TestDocument < PrawnCocktail::Document
  helper TestDocumentHelper

  def initialize(status)
    @status = status
  end

  private

  def data
    { status: @status }
  end
end
