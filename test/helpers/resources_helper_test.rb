##
# resources_helper_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class ResourcesHelperTest < ActionView::TestCase
    def setup
        @youtube_resource = FactoryGirl.create(:video_link_resource)
        @vimeo_video_link = FactoryGirl.create(:video_link_vimeo)
    end

    def teardown
        Resource.destroy_all
        Album.destroy_all
        VideoLink.destroy_all
    end

    test 'should get youtube embed iframe url' do
        assert_equal '<iframe src="http://www.youtube.com/embed/SILvPVVAhBo"></iframe>', embed(@youtube_resource.medium)
    end

    test 'should get vimeo embed iframe url' do
        assert_equal '<iframe src="http://player.vimeo.com/video/117669654"></iframe>', embed(@vimeo_video_link)
    end

    test 'should create images for album' do
        assert_not_nil setup_album(Album.new).images
    end

    test 'should build image for update album' do
        @album = FactoryGirl.create(:album_resource)
        assert_equal 2, update_album(@album.medium).images.count
    end
end
