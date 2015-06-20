##
# map_controller_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class ErrorsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    test 'should get 404 not found page' do
        get :show, code: 404
        assert_response :not_found
    end

    test 'should get 422 unprocessable entity page' do
        get :show, code: 422
        assert_response :unprocessable_entity
    end

    test 'should get 500 internal server error page' do
        get :show, code: 500
        assert_response :internal_server_error
    end
end
