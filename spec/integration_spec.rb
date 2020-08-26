require_relative "spec_helper"
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
      assert_equal(
        [ "Init works.", "Test document", "Status: success" ],
        parse_strings(data)
      )
    end

    it "has the right geometry" do
      assert_equal expected_geometry("A4"), parse_geometry(data)
    end
  end

  describe "#render_file" do
    let(:data) do
      TestDocument.new("success").render_file("/tmp/test_document.pdf")
      File.read("/tmp/test_document.pdf")
    end

    it "has the right contents" do
      assert_equal(
        [ "Init works.", "Test document", "Status: success" ],
        parse_strings(data)
      )
    end

    it "has the right geometry" do
      assert_equal expected_geometry("A4"), parse_geometry(data)
    end
  end

  describe "inheriting documents" do
    let(:data) do
      SubTestDocument.new("success").render
    end

    it "inherits initializers and helpers" do
      assert_equal(
        [ "Init works.", "Sub-init works.", "Sub test document", "Status: success" ],
        parse_strings(data)
      )
    end
  end
end

def parse_strings(pdf_data)
  PDF::Inspector::Text.analyze(pdf_data).strings
end

def parse_geometry(pdf_data)
  PDF::Inspector::Page.analyze(pdf_data).pages.first[:size]
end

def expected_geometry(name)
  PDF::Core::PageGeometry::SIZES[name]
end
