##
# static_helper_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class StaticHelperTest < ActionView::TestCase
    test 'should return div container with given values' do
        expected = "<div class=\"team-member\"><div class=\"team-picture\" id=\"stephan\"></div><p class=\"team-name\">Stephan Griessner</p><p class=\"team-studie\">MMT</p><p class=\"team-work\">Development</p></div>"
        assert_equal expected, team_member('stephan', 'Stephan Griessner', 'MMT', 'Development')
    end
end
