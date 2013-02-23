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
    parse_strings(data)
  )

  assert_equal(
    parse_geometry(data),
    expected_geometry("A4")
  )
end

def parse_strings(pdf_data)
  PDF::Inspector::Text.analyze(pdf_data).strings
end

def parse_geometry(pdf_data)
  PDF::Inspector::Page.analyze(pdf_data).pages.first[:size]
end

def expected_geometry(name)
  Prawn::Document::PageGeometry::SIZES[name]
end
