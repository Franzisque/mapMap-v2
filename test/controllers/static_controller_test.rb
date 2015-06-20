##
# static_controller_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class StaticControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    test 'should get about page' do
        get :about
        assert_response :success
    end

    test 'should get imprint page' do
        get :imprint
        assert_response :success
    end
end
