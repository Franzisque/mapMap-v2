##
# resource_steps_helper_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class ResourceStepsHelperTest < ActionView::TestCase
    test 'should return active step container' do
        expected_html = "<div class=\"select step-overview active-step\">test</div>"
        assert_equal expected_html, step_container('select', 'select') { 'test' }
    end

    test 'should return normal step container' do
        expected_html = "<div class=\"select step-overview\">test</div>"
        assert_equal expected_html, step_container('media', 'select') { 'test' }
    end
end
