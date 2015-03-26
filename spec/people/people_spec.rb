require 'spec_helper'

describe People do
  describe "With standard name variations" do
    before( :each ) do
      @np = People::NameParser.new
    end

    it "parses first initial, last name" do
      name = @np.parse( "M ERICSON" )
      expect(name[:parsed]).to be_truthy
      expect(name[:first]).to eq "M"
      expect(name[:last]).to eq "Ericson"
    end

    it "parses first initial, middle initial, last name" do
      name = @np.parse( "M E ERICSON" )
      expect(name[:parsed]).to be_truthy
      expect(name[:first]).to eq "M"
      expect(name[:middle]).to eq "E"
      expect(name[:last]).to eq "Ericson"
    end

    it "parses first initial with period, middle initial with period, last name" do
      name = @np.parse( "M.E. ERICSON" )
      expect(name[:parsed]).to be_truthy
      expect(name[:first]).to eq "M"
      expect(name[:middle]).to eq "E"
      expect(name[:last]).to eq "Ericson"
    end

    it "parses first initial, two middle initials, last name" do
      name = @np.parse( "M E E  ERICSON" )
      expect(name[:parsed]).to be_truthy
      expect(name[:first]).to eq "M"
      expect(name[:middle]).to eq "E E"
      expect(name[:last]).to eq "Ericson"
    end

    it "parses first initial, middle name, last name" do
      name = @np.parse( "M EDWARD ERICSON" )
      expect(name[:parsed]).to be_truthy
      expect(name[:first]).to eq "M"
      expect(name[:middle]).to eq 'Edward'
      expect(name[:last]).to eq "Ericson"
    end

    it "parses first name, middle initial, last name" do
      name = @np.parse( "MATTHEW E ERICSON" )
      expect(name[:parsed]).to be_truthy
      expect(name[:first]).to eq "Matthew"
      expect(name[:middle]).to eq "E"
      expect(name[:last]).to eq "Ericson"
    end

    it "parses first name, two middle initials, last name" do
      name = @np.parse( "MATTHEW E E ERICSON" )
      expect(name[:parsed]).to be_truthy
      expect(name[:first]).to eq "Matthew"
      expect(name[:middle]).to eq "E E"
      expect(name[:last]).to eq "Ericson"
    end

    it "parses 'first middle initial middle initial (with periods) last'" do
      name = @np.parse( "MATTHEW E.E. ERICSON" )
      expect(name[:parsed]).to be_truthy
      expect(name[:first]).to eq "Matthew"
      expect(name[:middle]).to eq "E.E."
      expect(name[:last]).to eq "Ericson"
    end

    it "parses triple initials and last name" do
      name = @np.parse( "M.E.E. ERICSON" )
      expect(name[:parsed]).to be_truthy
      expect(name[:first]).to eq "M"
      expect(name[:middle]).to eq "E E"
      expect(name[:last]).to eq "Ericson"
    end

    it "parses 'first last'" do
      name = @np.parse( "MATTHEW ERICSON" )
      expect(name[:parsed]).to be_truthy
      expect(name[:first]).to eq "Matthew"
      expect(name[:last]).to eq "Ericson"
    end

    it "parses 'first middle last'" do
      name = @np.parse( "MATTHEW EDWARD ERICSON" )
      expect(name[:parsed]).to be_truthy
      expect(name[:first]).to eq "Matthew"
      expect(name[:middle]).to eq 'Edward'
      expect(name[:last]).to eq "Ericson"
    end

    it "parses 'first middle initial middle last'" do
      skip( "not reliable" ) do
        name = @np.parse( "MATTHEW E. SHEIE ERICSON" )
        expect(name[:parsed]).to be_truthy
        expect(name[:first]).to eq "Matthew"
        expect(name[:middle]).to eq "E. Sheie"
        expect(name[:last]).to eq "Ericson"
      end
    end
  end

end
