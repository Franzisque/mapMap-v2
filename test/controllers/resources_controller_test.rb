##
# resources_controller_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class ResourcesControllerTest < ActionController::TestCase
    include Devise::TestHelpers
    include ActionDispatch::TestProcess

    def setup
        @user = FactoryGirl.create(:user_facebook)
        @resource_album = FactoryGirl.create(:album_resource)
        Tag.main_tags.each do |name|
            Tag.where(name: name).first_or_create
        end
    end

    def teardown
        Resource.destroy_all
        User.destroy_all
        Tag.destroy_all
    end

    test 'user needs to be signed in to create resources' do
        get :new
        assert_response :redirect
        assert_redirected_to user_session_path
    end

    test 'user cant edit other resources' do
        sign_in @user

        get :edit, id: @resource_album
        assert_response :redirect
        assert_redirected_to root_path
        assert_equal 'You are not authorized to access this page.', flash[:alert]
    end

    test 'should get index as html' do
        get :index
        assert_response :success
        assert_not_nil assigns(:resources)
    end

    test 'should get index as json' do
        get :index, format: 'json'
        assert_response :success
        assert_not_nil assigns(:resources)
    end

    test 'should show resource' do
        get :show, id: @resource_album
        assert_response :success
        assert_not_nil assigns(:resource)
    end

    test 'new should redirect to resource_steps' do
        sign_in @user
        get :new
        assert_response :redirect
        assert_redirected_to resource_steps_path
    end

    test 'should get edit' do
        sign_in @resource_album.user
        get :edit, id: @resource_album
        assert_response :success
    end

    test 'should destroy resource and all associations' do
        sign_in @resource_album.user
        assert_difference 'Resource.count', -1 do
            delete :destroy, id: @resource_album
        end
        assert_equal 0, Album.all.count
        assert_equal 0, Image.all.count
        assert_redirected_to profile_path(@resource_album.user.username)
    end

    test 'should be able to vote resource' do
        sign_in @resource_album.user
        post :vote, id: @resource_album.id, vote: 'up', format: 'js'
        assert_response :success
    end

    test 'should not be able to vote' do
        post :vote, id: @resource_album.id, vote: 'up', format: 'js'
        assert_response :unauthorized
    end

    test 'should get status of uploaded video' do
        @video_resource = FactoryGirl.create(:video_upload_resource)
        get :status, id: @video_resource.id, format: 'json'
        assert_not_nil assigns(:resource)
        assert_response :success
    end
end
