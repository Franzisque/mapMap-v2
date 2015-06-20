##
# country_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class CountryTest < ActiveSupport::TestCase
    def setup
        @country_empty = Country.new
    end

    def teardown
        Country.destroy_all
    end

    test 'must not be empty' do
        assert @country_empty.invalid?
        assert @country_empty.errors.any?
    end

    test 'presence of name and code' do
        @country = Country.new(name: 'Austria', code: 'AT')
        assert @country.valid?
        assert_not @country.errors.any?
    end
end
