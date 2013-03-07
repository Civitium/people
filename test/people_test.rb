require 'test_helper'

# TODO: these need to be broken up into different scenarios, but my test data was already in this format.


class PeopleTest < Test::Unit::TestCase
  def setup
    @tests=<<NAMES
Powell, Thomas W, M.D.|Thomas|W|Powell|M.D.
Thomas W Powell, M.D.|Thomas|W|Powell|M.D.
Thomas W Powell M.D.|Thomas|W|Powell|M.D.
Thomas D W Wizard, MD|Thomas|D W|Wizard|MD
Thomas William M Powell, DVM|Thomas|William M|Powell|DVM
Thomas M William Powell, DVM|Thomas|M|William Powell|DVM
Thomas D W Wizard, MD, Ph D|Thomas|D W|Wizard|MD, Ph D
Wizard, Thomas D W, MD, Ph D|Thomas|D W|Wizard|MD, Ph D
VAN ADELSBERG, JOOST HENRI MD|JOOST|HENRI|VAN ADELSBERG|MD
AVERY, MARSDEN RONALD JR MD|MARSDEN|RONALD|AVERY|JR, MD
ALBERTSON, KENNETH W MD|KENNETH|W|ALBERTSON|MD
Thomas William Constant-Powell DVM MD|Thomas|William|Constant-Powell|DVM, MD
Constant-Powell, Thomas William DVM MD|Thomas|William|Constant-Powell|DVM, MD
NAMES

    @tests_symbol_mapping = {
      :first => 1,
      :middle => 2,
      :last => 3,
      :suffix => 4
    }

    @np = People::NameParser.new
  end

  def check_parse
  end

  def check_piece_insensitive(source, symbol, expected, actual)
      assert_equal(expected.upcase, actual.upcase, "#{source} didn't parse correctly. Expected #{expected}, but got #{actual}")
  end

  def test_names_to_successfully_parse
    @tests.each_line do |line|
      line.strip!
      parse_definitions = line.split('|')
      parse = @np.parse(parse_definitions[0])
      assert(parse[:parsed], "#{parse_definitions[0]} failed to parse.\nOutput hash: #{parse}")
      @tests_symbol_mapping.each do |k,v|
        puts parse if parse_definitions[v].upcase != parse[k].upcase
        check_piece_insensitive(parse_definitions[0], k, parse_definitions[v], parse[k])
      end
    end
  end
end
