require_relative "spec_helper"

describe PrawnCocktail::Renderer do
  describe "#meta" do
    it "merges options if run multiple times" do
      subject = PrawnCocktail::Renderer.new(nil, nil, nil)
      subject.meta one: nil, two: 2
      subject.meta one: 1, three: 3

      expected = { one: 1, two: 2, three: 3 }
      assert_equal expected, subject.send(:prawn_document_options)
    end
  end
end
