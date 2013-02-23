require "minitest/autorun"
require "minitest/pride"
require "pdf/inspector"

require "prawn_cocktail"

PrawnCocktail.template_root = "spec/templates"

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

describe PrawnCocktail do
  it "works" do
    data = TestDocument.new("success").render
    assert_equal [ "Test document", "Status: success" ], strings(data)
  end
end

def strings(pdf_data)
  PDF::Inspector::Text.analyze(pdf_data).strings
end
