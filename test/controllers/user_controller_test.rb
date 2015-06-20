##
# user_controller_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class UserControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    def setup
        @user = FactoryGirl.create(:user)
        sign_in @user
    end

    def teardown
        User.destroy_all
    end

    test 'show profile of user' do
        get :show, username: @user.username
        assert_response :success
        assert_not_nil assigns(:user)
    end

    test 'should redirect to root path if user not found' do
        get :show, username: 'max'
        assert_response :redirect
        assert_redirected_to root_path
        assert_equal 'User not found', flash[:alert]
    end

    test 'should get all usernames' do
        get :index, format: 'json'
        assert_response :success
        assert_not_nil assigns(:users)
    end
end
