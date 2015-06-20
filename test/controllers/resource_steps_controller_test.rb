##
# resource_steps_controller_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class ResourceStepsControllerTest < ActionController::TestCase
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

    test 'should get first step - select' do
        sign_in @user
        get :show, id: :select
        assert_response :success
        assert_template :select
    end

    test 'should get second step - media' do
        sign_in @user
        get(:show, id: :media, medium: 'VideoLink')
        assert_response :success
        assert_template :media
        assert_not_nil assigns(:resource)
    end

    test 'should redirect to first step - media' do
        sign_in @user
        get(:show, id: :media, medium: 'Video')
        assert_response :redirect
        assert_equal 'Please select a valid media', flash[:alert]
    end

    test 'should get last step - tracking' do
        sign_in @resource_album.user
        get :show, id: :tracking
        assert_response :success
        assert_template :tracking
        assert_not_nil assigns(:resource)
    end

    test 'should redirect to first step - tracking' do
        sign_in @user
        get :show, id: :tracking
        assert_response :redirect
        assert_equal 'No media available', flash[:alert]
    end

    test 'should create new video link (resource)' do
        sign_in @resource_album.user

        create_link = {
            title: 'Test',
            description: 'Test description',
            tag_list: 'mountain_biking',
            medium_type: 'VideoLink',
            medium_attributes: {
                link: 'https://www.youtube.com/watch?v=SILvPVVAhBo'
            }
        }

        assert_difference 'Resource.count' do
            post :create, resource: create_link
        end

        assert_response :redirect
        assert_not_nil assigns(:resource)
    end

    test 'should not create new video link' do
        sign_in @resource_album.user

        create_link = {
            title: 'Test',
            description: 'Test description',
            medium_type: 'VideoLink',
            medium_attributes: {
                link: 'https://www.you.com/watch?v=SILVAhBo'
            }
        }

        assert_no_difference 'Resource.count' do
            post :create, resource: create_link
        end

        assert_template :media
        assert_not_nil assigns(:resource)
    end

    test 'should update resource - tracking' do
        sign_in @resource_album.user
        tracks = {
            tracks_attributes: {
                '0' => {
                    latitude: 65.9,
                    longitude: 45.8
                }
            }
        }

        assert_difference 'Track.count' do
            put :update, id: :tracking, resource: tracks
        end

        assert_response :redirect
    end
end
