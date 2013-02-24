module TestDocumentHelper
  def status_line(status)
    text "Status: #{status}"
  end
end

class TestDocument < PrawnCocktail::Document
  helper TestDocumentHelper
  initialize_template { text "Init works." }

  def initialize(status)
    @status = status
  end

  private

  def data
    { status: @status }
  end
end

class SubTestDocument < TestDocument
  initialize_template { text "Sub-init works." }
end
