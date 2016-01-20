require 'spec_helper'

describe People do
  describe "With multiple names" do
    before( :each ) do
      @np = People::NameParser.new
    end

    it "doesn't crash on 邹鸿志" do
      expect { @np.parse("邹鸿志") }.to_not raise_error
    end
  end
end
