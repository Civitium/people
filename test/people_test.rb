require 'test_helper'

# TODO: these need to be broken up into different scenarios, but my test data was already in this format.


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

    should "parse multi 'MATTHEW E. SHEIE ERICSON'" do
      res = parser.parse("MATTHEW E. SHEIE ERICSON")
      assert res[:parsed], "parse failed"
      assert_equal "Matthew", res[:first]
      assert_equal "Sheie Ericson", res[:last], "Last name not equal"
    end

    should "parse Unicode 'Anders Ølsen'" do
      res = parser.parse("Anders Ølsen")
      assert res[:parsed], "parse failed"
      assert_equal "Anders", res[:first]
      assert_equal "Ølsen", res[:last], "Last name not equal"
    end

    should "parse multiple single initials 'M.E.N. ERICSON'" do
      initials_src.each do |source|
        name, compare = source
        res = parser.parse(name)
        assert res[:parsed], "Initials: #{name}, did not parse"
        assert_equal compare, res[:first], "#{compare} does not equal #{res[:first]}"
        assert_equal "Last", res[:last], "#{res[:last]} does not equal 'Last'"
      end
    end
  end

  def initials_src
    [
      ["F. Last", "F"],
      ["F.I. Last", "F"],
      ["F.I.R. Last", "F.I.R."],
      ["F.I.R.S. Last", "F.I.R.S."],
      ["F.I.R.S.T. Last", "F.I.R.S.T."]
    ]
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
#  def setup
#    @tests=<<NAMES
#Powell, Thomas W, M.D.|Thomas|W|Powell|M.D.
#Thomas W Powell, M.D.|Thomas|W|Powell|M.D.
#Thomas W Powell M.D.|Thomas|W|Powell|M.D.
#Thomas D W Wizard, MD|Thomas|D W|Wizard|MD
#Thomas William M Powell, DVM|Thomas|William M|Powell|DVM
#Thomas M William Powell, DVM|Thomas|M|William Powell|DVM
#Thomas D W Wizard, MD, Ph D|Thomas|D W|Wizard|MD, Ph D
#Wizard, Thomas D W, MD, Ph D|Thomas|D W|Wizard|MD, Ph D
#VAN ADELSBERG, JOOST HENRI MD|JOOST|HENRI|VAN ADELSBERG|MD
#AVERY, MARSDEN RONALD JR MD|MARSDEN|RONALD|AVERY|JR, MD
#ALBERTSON, KENNETH W MD|KENNETH|W|ALBERTSON|MD
#Thomas William Constant-Powell DVM MD|Thomas|William|Constant-Powell|DVM, MD
#Constant-Powell, Thomas William DVM MD|Thomas|William|Constant-Powell|DVM, MD
#NAMES

#    @tests_symbol_mapping = {
#      :first => 1,
#      :middle => 2,
#      :last => 3,
#      :suffix => 4
#    }

#    @np = People::NameParser.new
#  end

#  def check_parse
#  end

#  def check_piece_insensitive(source, symbol, expected, actual)
#      assert_equal(expected.upcase, actual.upcase, "#{source} didn't parse correctly. Expected #{expected}, but got #{actual}")
#  end

#  def test_names_to_successfully_parse
#    @tests.each_line do |line|
#      line.strip!
#      parse_definitions = line.split('|')
#      parse = @np.parse(parse_definitions[0])
#      assert(parse[:parsed], "#{parse_definitions[0]} failed to parse.\nOutput hash: #{parse}")
#      @tests_symbol_mapping.each do |k,v|
#        puts parse if parse_definitions[v].upcase != parse[k].upcase
#        check_piece_insensitive(parse_definitions[0], k, parse_definitions[v], parse[k])
#      end
#    end
  
end
