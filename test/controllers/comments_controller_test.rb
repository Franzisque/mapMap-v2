##
# comments_controller_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    def setup
        @user = FactoryGirl.create(:user)
        @resource = FactoryGirl.create(:video_link_resource)
        sign_in @user
        @comment = Comment.create(text: 'test', user: @user, resource: @resource)
    end

    def teardown
        Resource.destroy_all
        User.destroy_all
    end

    test 'user needs to be signed in to create comments' do
        sign_out @user
        get :edit, medium_id: @resource, id: @comment
        assert_response :redirect
        assert_redirected_to user_session_path
    end

    test 'user cant edit other comments' do
        sign_out @user

        @fb_user = FactoryGirl.create(:user_facebook)
        sign_in @fb_user

        get :edit, medium_id: @resource, id: @comment
        assert_response :redirect
        assert_redirected_to root_path
        assert_equal 'You are not authorized to access this page.', flash[:alert]
    end

    test 'should create new comment' do
        create_comment = {
            text: 'Another test'
        }

        assert_difference 'Comment.count' do
            post :create, comment: create_comment, medium_id: @resource
        end

        assert_response :redirect
        assert_redirected_to medium_path(@resource)
    end

    test 'should get edit' do
        get :edit, medium_id: @resource, id: @comment
        assert_response :success
    end

    test 'should update comment' do
        put :update, medium_id: @resource, id: @comment, comment: { text: 'updated test' }
        assert_redirected_to medium_path(@resource)

        @comment.reload
        assert_equal 'updated test', @comment.text
    end

    test 'should destroy comment' do
        assert_difference 'Comment.count', -1 do
            delete :destroy, medium_id: @resource, id: @comment
        end
        assert_equal 0, Comment.all.count
        assert_redirected_to medium_path(@resource)
    end
end
