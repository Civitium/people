require 'spec_helper'

describe People do
  describe "With case options" do
    it "changes all upper case to proper case" do
      proper_np = People::NameParser.new( :case_mode => 'proper' )
      name = proper_np.parse( "MATTHEW ERICSON" )
      expect(name[:first]).to eq "Matthew"
      expect(name[:last]).to eq "Ericson"
    end

    it "changes proper case to upper case" do
      proper_np = People::NameParser.new( :case_mode => 'upper' )
      name = proper_np.parse( "Matthew Ericson" )
      expect(name[:first]).to eq "MATTHEW"
      expect(name[:last]).to eq "ERICSON"
    end

    it "leave case as is" do
      proper_np = People::NameParser.new( :case_mode => 'leave' )
      name = proper_np.parse( "mATTHEW eRicSon" )
      expect(name[:first]).to eq "mATTHEW"
      expect(name[:last]).to eq "eRicSon"
    end

  end

end