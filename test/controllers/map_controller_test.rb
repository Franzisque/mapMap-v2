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

class MapControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    def setup
        @link_resource = FactoryGirl.create(:video_link_resource)
        Tag.main_tags.each do |name|
            Tag.where(name: name).first_or_create
        end
    end

    def teardown
        User.destroy_all
        Resource.destroy_all
        Tag.destroy_all
    end

    test 'should get index and main tags' do
        get :index
        assert_response :success
        assert_not_nil assigns(:season_tags)
        assert_not_nil assigns(:door_tags)
        assert_not_nil assigns(:level_tags)
    end

    test 'should get index with given tag' do
        get :index, tag: 'summer'
        assert_response :success
        assert_not_nil assigns(:resources)
    end
end
