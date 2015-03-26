require 'spec_helper'

describe People do
  describe "With complex names" do
    before( :each ) do
      @np = People::NameParser.new
    end

    it "parses a multiple-word last name - Matthew De La Hoya" do
      name = @np.parse( "Matthew De La Hoya" )
      expect(name[:parsed]).to be_truthy
      expect(name[:last]).to eq "De La Hoya"
    end

    it "parses a camel case last name - Matthew McIntosh" do
      name = @np.parse( "Matthew McIntosh" )
      expect(name[:parsed]).to be_truthy
      expect(name[:last]).to eq "McIntosh"
    end

    it "parses apostrophe'd name - Gavan O'Herlihy" do
      name = @np.parse("Gavan O'Herlihy")
      expect(name[:parsed]).to be_truthy
      expect(name[:first]).to eq "Gavan"
      expect(name[:last]).to eq "O'Herlihy"
    end

    it "parses apostrophe'd alternate name - Gavan Ó Herlihy" do
      name = @np.parse("Gavan Ó Herlihy")
      expect(name[:parsed]).to be_truthy
      expect(name[:first]).to eq "Gavan"
      expect(name[:last]).to eq "Ó Herlihy"
    end

  end

end