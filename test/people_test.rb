require 'test_helper'

class PeopleTest < Test::Unit::TestCase
  context "People::NameParser" do
    should "parse new titles" do
      title_src.each do |source|
        title, compare = source
        compare ||= "#{title} "
        src = make_src(title)
        res = parser.parse(src)
        assert res[:parsed], "Title: #{title}, did not parse"
        assert_equal compare, res[:title], "#{compare} does not equal #{res[:title]}"
        assert_equal "First", res[:first]
        assert_equal "Last", res[:last]
      end
    end

    should "parse 'van de'" do
      res = parser.parse("First van de Last")
      assert res[:parsed], "parse failed"
      assert_equal "First", res[:first]
      assert_equal "Van De Last", res[:last], "Last name not equal"
    end

    should "parse 'de del den des de la' etc" do
      middle_src.each do |source|
        mid, compare = source
        compare ||= "#{mid} Last"
        res = parser.parse("First #{compare}")
        assert res[:parsed], "Middle: #{mid}, did not parse"
        assert_equal compare.downcase, res[:last].downcase, "#{compare} does not equal #{res[:last]}"
      end
    end

    should "parse 'Robert Delaunay' " do
      res = parser.parse("Robert Delaunay")
      assert res[:parsed], "parse failed"
      assert_equal "Robert", res[:first]
      assert_equal "Delaunay", res[:last], "Last name not equal"
    end

    should "parse 'Bob Destiny' " do
      res = parser.parse("Bob Destiny")
      assert res[:parsed], "parse failed"
      assert_equal "Bob", res[:first]
      assert_equal "Destiny", res[:last], "Last name not equal"
    end

  end

  def parser(opts = {})
    People::NameParser.new(opts)
  end

  def make_src(title)
    "#{title} First Last"
  end

  def middle_src
    [["de"],["del"],["den"],["des"],["de la"],["de las"],["de los"]]
  end

  def title_src
    [
      ["Herr"], ["Frau"], ["Count"], ["Countess"], ["Baroness"],
      ["Dhr"], ["Dhr."], ["Hr."], ["Fr."], ["Sr."], ["Sra."], ["Srta."],
      ["Signore"], ["Signora"], ["Sig."], ["Sig.a", "Sig.A "], ["Sig.ra", "Sig.Ra "]
    ]
  end
end
