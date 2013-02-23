require "minitest/autorun"
require "minitest/pride"
require "pdf/inspector"

require "prawn_cocktail"

PrawnCocktail.template_root = "spec/fixtures"
require_relative "fixtures/document"

describe PrawnCocktail do
  let(:data) do
    TestDocument.new("success").render
  end

  describe "#render" do
    it "has the right contents" do
      assert_document_has_the_right_contents
    end

    it "has the right geometry" do
      assert_document_has_the_right_geometry
    end
  end

  describe "#render_file" do
    let(:data) do
      TestDocument.new("success").render_file("/tmp/test_document.pdf")
      data = File.read("/tmp/test_document.pdf")
    end

    it "has the right contents" do
      assert_document_has_the_right_contents
    end

    it "has the right geometry" do
      assert_document_has_the_right_geometry
    end
  end
end

def assert_document_has_the_right_contents
  assert_equal(
    [ "Init works.", "Test document", "Status: success" ],
    parse_strings(data)
  )
end

def assert_document_has_the_right_geometry
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
