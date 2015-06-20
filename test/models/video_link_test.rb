##
# video_link_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class VideoLinkTest < ActiveSupport::TestCase
    def setup
        @video_link = VideoLink.new
    end

    def teardown
        VideoLink.destroy_all
    end

    test 'video link must not be empty' do
        assert @video_link.invalid?
        assert @video_link.errors[:link].any?
    end

    test 'valid youtube links' do
        @video_link.link = 'https://www.youtube.com/watch?v=SILvPVVAhBo'
        assert @video_link.valid?

        @video_link.link = 'http://youtube.com/watch?v=SILvPVVAhBo'
        assert @video_link.valid?

        @video_link.link = 'http://www.youtu.be/SILvPVVAhBo'
        assert @video_link.valid?

        @video_link.link = 'http://youtu.be/SILvPVVAhBo'
        assert @video_link.valid?
    end

    test 'invalid youtube links' do
        @video_link.link = 'https://www.youtube.com/'
        assert @video_link.invalid?
        assert_equal ['is not a valid youtube/vimeo url'], @video_link.errors[:link]

        @video_link.link = 'http://www.youtube.com/watch?v='
        assert @video_link.invalid?

        @video_link.link = 'http://www.youtu.be.com/watch?v=1234567890'
        assert @video_link.invalid?
    end

    test 'valid vimeo links' do
        @video_link.link = 'https://vimeo.com/118643506'
        assert @video_link.valid?

        @video_link.link = 'https://vimeo.com/channels/stuffpicks/118643506'
        assert @video_link.valid?
    end

    test 'invalid vimeo links' do
        @video_link.link = 'https://vimeo.com/'
        assert @video_link.invalid?
        assert_equal ['is not a valid youtube/vimeo url'], @video_link.errors[:link]

        @video_link.link = 'http://vimeo.com/12345'
        assert @video_link.invalid?
    end

    test 'define provider to be youtube' do
        @video_link.link = 'https://www.youtube.com/watch?v=SILvPVVAhBo'
        assert @video_link.save
        assert_equal 'youtube', @video_link.provider
    end

    test 'define provider to be vimeo' do
        @video_link.link = 'https://vimeo.com/118643506'
        assert @video_link.save
        assert_equal 'vimeo', @video_link.provider
    end

    test 'get and store video id from youtube link' do
        @video_link.link = 'https://www.youtube.com/watch?v=SILvPVVAhBo'
        assert @video_link.save
        assert_equal 'SILvPVVAhBo', @video_link.vid
    end

    test 'get and store video id from vimeo link' do
        @video_link.link = 'https://vimeo.com/118643506/'
        assert @video_link.save
        assert_equal '118643506', @video_link.vid
    end

    test 'get and store youtube video thumb path' do
        @video_link.link = 'https://www.youtube.com/watch?v=SILvPVVAhBo'
        @video_link.save
        assert_equal 'http://img.youtube.com/vi/SILvPVVAhBo/mqdefault.jpg', @video_link.thumb_path
    end

    test 'get and store vimeo video thumb path' do
        @video_link.link = 'https://vimeo.com/channels/stuffpicks/118643506'
        @video_link.save
        assert_equal 'http://i.vimeocdn.com/video/506488376_640.jpg', @video_link.thumb_path
    end

    test 'should return the thumb image url' do
        @video_link.link = 'https://www.youtube.com/watch?v=SILvPVVAhBo'
        @video_link.save
        assert_equal 'http://img.youtube.com/vi/SILvPVVAhBo/mqdefault.jpg', @video_link.thumburl
    end

    test 'should return the size' do
        @video_link.link = 'https://www.youtube.com/watch?v=SILvPVVAhBo'
        @video_link.save
        assert_equal 0, @video_link.size
    end
end
