require 'spec_helper'

describe People do
  describe "with names" do
    before( :each ) do
      @np = People::NameParser.new
    end

    it "doesn't crash on" do
      expect { @np.parse("邹鸿志") }.to_not raise_error
      expect { @np.parse("Gordon Xi") }.to_not raise_error
    end
  end
end
