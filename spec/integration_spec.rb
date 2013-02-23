require "minitest/autorun"
require "minitest/pride"
require "pdf/inspector"

require "prawn_cocktail"

PrawnCocktail.template_root = "spec/fixtures"
require_relative "fixtures/document"

describe PrawnCocktail do
  describe "#render" do
    it "works" do
      data = TestDocument.new("success").render
      assert_test_document data
    end
  end

  describe "#render_file" do
    it "works" do
      TestDocument.new("success").render_file("/tmp/test_document.pdf")
      data = File.read("/tmp/test_document.pdf")
      assert_test_document data
    end
  end
end

def assert_test_document(data)
  assert_equal(
    [ "Init works.", "Test document", "Status: success" ],
    strings(data)
  )
end

def strings(pdf_data)
  PDF::Inspector::Text.analyze(pdf_data).strings
end
