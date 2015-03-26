require 'spec_helper'

describe People do
  describe "With Dutch names" do
    before( :each ) do
      @np = People::NameParser.new
    end

    # see https://github.com/mericson/people/issues/2
    it "parses Gerard Van 't Hooft" do
      name = @np.parse("Gerard Van 't Hooft")
      expect(name[:parsed]).to be_truthy
      expect(name[:first]).to eq "Gerard"
      expect(name[:last]).to eq "Van 't Hooft"
    end

    it "parses Gerard 't Hooft" do
      name = @np.parse("Gerard 't Hooft")
      expect(name[:parsed]).to be_truthy
      expect(name[:first]).to eq "Gerard"
      expect(name[:last]).to eq "'t Hooft"
    end

  end
end