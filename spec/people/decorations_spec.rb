require 'spec_helper'

describe People do
  describe "With names having decorations" do
    before( :each ) do
      @np = People::NameParser.new
    end

    it "parses the suffix - 'Jr'" do
      name = @np.parse( "Matthew E Ericson Jr" )
      expect(name[:parsed]).to be_truthy
      expect(name[:suffix]).to eq "Jr"
    end

    it "parses a roman numeral suffix - III" do
      name = @np.parse( "Matthew E Ericson III" )
      expect(name[:parsed]).to be_truthy
      expect(name[:suffix]).to eq "III"
    end

    it "parses suffix with periods - M.D." do
      name = @np.parse( "Matthew E Ericson M.D." )
      expect(name[:parsed]).to be_truthy
      expect(name[:suffix]).to eq "M.D."
    end

    it "parses two suffixes - Jr. M.D." do
      name = @np.parse( "Matthew E Ericson Jr. M.D." )
      expect(name[:parsed]).to be_truthy
      expect(name[:suffix]).to eq "Jr. M.D."
    end

    it "parses a title - Mr" do
      name = @np.parse( "Mr Matthew E Ericson" )
      expect(name[:parsed]).to be_truthy
      expect(name[:title]).to eq "Mr"
    end

    it "parses a title with a period - Mr." do
      name = @np.parse( "Mr. Matthew E Ericson" )
      expect(name[:parsed]).to be_truthy
      expect(name[:title]).to eq "Mr."
    end

    it "parses a title, first initial - Rabbi M" do
      name = @np.parse( "Rabbi M Edward Ericson" )
      expect(name[:parsed]).to be_truthy
      expect(name[:title]).to eq "Rabbi"
      expect(name[:first]).to eq "M"
    end

    it "parses 1950s style married couple name" do
      name = @np.parse( "Mr. and Mrs. Matthew E Ericson" )
      expect(name[:parsed]).to be_truthy
      expect(name[:title]).to eq "Mr. And Mrs."
      expect(name[:first]).to eq "Matthew"
    end

    it "parses multiple suffixes with no period - JD, PhD" do
      name = @np.parse('Eric E. Silverman JD, PhD')
      expect(name[:first]).to eq "Eric"
      expect(name[:suffix]).to eq "PhD JD"
    end
  end
end
