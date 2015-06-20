##
# messages_controller_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    def setup
        @user = FactoryGirl.create(:user)
        @fb_user = FactoryGirl.create(:user_facebook)
        sign_in @user
        @message = Message.create!(text: 'Yet another test', sender: @fb_user, receiver: @user)
    end

    def teardown
        User.destroy_all
        Message.destroy_all
    end

    test 'should get message index view' do
        get :index
        assert_response :success
        assert_not_nil assigns(:messages)
    end

    test 'should get message index view with given username' do
        get :index, username: @fb_user.username
        assert_response :success
        assert_not_nil assigns(:messages)
    end

    test 'should redirect to root path - index: user not found' do
        get :index, username: 'test'
        assert_response :redirect
        assert_equal 'User not found', flash[:alert]
    end

    test 'should redirect to root path - index: user send himself' do
        get :index, username: @user.username
        assert_response :redirect
        assert_equal 'Cannot send messages to yourself', flash[:alert]
    end

    test 'should get new message view' do
        get :new, receiver_id: @fb_user.id
        assert_response :success
    end

    test 'should redirect to root path - new: user not found' do
        get :new
        assert_response :redirect
        assert_equal 'User not found', flash[:alert]
    end

    test 'should create new message' do
        assert_difference('Message.count') do
            post :create, message: { text: 'Yet another test', receiver_id: @fb_user.id }
        end

        assert_redirected_to usermessage_path(@fb_user.username)
    end

    test 'should not create new message - not allowed' do
        @fb_user.allowcontact = false
        @fb_user.save

        post :create, message: { text: 'Yet another test', receiver_id: @fb_user.id }
        assert_redirected_to usermessage_path(@fb_user.username)
        assert_equal "User doesn't want to receive Messages", flash[:alert]
    end

    test 'should give alert if user has allowcontact false' do
        @user.update(allowcontact: false)

        post :create, message: { text: 'Yet another test', receiver_id: @fb_user.id }
        assert_redirected_to usermessage_path(@fb_user.username)
        assert_equal "You can't send messages, if you dont want to receive messages.", flash[:alert]
    end

    test 'should delete message' do
        assert_difference('Message.count', -1) do
            delete :destroy, id: @message
        end

        assert_redirected_to usermessage_path(@fb_user.username)
    end
end
