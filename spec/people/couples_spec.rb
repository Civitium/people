require 'spec_helper'

describe People do
  describe "With multiple names" do
    before( :each ) do
      @np = People::NameParser.new( :couples => true )
    end

    it "parses first names and last name - Joe and Jill Hill" do
      name = @np.parse( "Joe and Jill Hill" )
      expect(name[:parsed]).to be_truthy
      expect(name[:multiple]).to be_truthy
      expect(name[:parsed2]).to be_truthy
      expect(name[:first2]).to  eq "Jill"
    end

    it "parses first names, middle initial, last name - Joe and Jill S Hill" do
      name = @np.parse( "Joe and Jill S Hill" )
      expect(name[:parsed]).to be_truthy
      expect(name[:multiple]).to be_truthy
      expect(name[:parsed2]).to be_truthy
      expect(name[:first2]).to eq "Jill"
      expect(name[:middle2]).to eq "S"
    end

    it "parses first names, middle initial, last name - Joe S and Jill Hill" do
      name = @np.parse( "Joe S and Jill Hill" )
      expect(name[:parsed]).to be_truthy
      expect(name[:multiple]).to be_truthy
      expect(name[:parsed2]).to be_truthy
      expect(name[:first2]).to eq "Jill"
      expect(name[:middle]).to eq "S"
    end

  end
end