##
# video_upload_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class VideoUploadTest < ActiveSupport::TestCase
    def setup
        @video = VideoUpload.new
        @video2 = VideoUpload.new(
            upload_file_name: 'test.mp4',
            upload_content_type: 'video/mp4',
            upload_file_size: 4000.0,
            upload_updated_at: Time.now
        )
    end

    def teardown
        Resource.destroy_all
    end

    test 'video must not be empty' do
        assert @video.invalid?
        assert @video.errors[:upload].any?
    end

    test 'valid video content type' do
        content_types = %w(video/mp4 video/m4v video/mov video/mpeg4)

        content_types.each do |type|
            @video2.upload_content_type = type
            assert @video2.valid?, "#{type} should be valid"
        end
    end

    test 'invalid image content type' do
        invalid_content_types = %w(image/jpg audio/ogg application/ogg application/pdf)

        invalid_content_types.each do |type|
            @video2.upload_content_type = type
            assert @video2.invalid?, "#{type} should not be valid"
            assert_equal ['must be a video file'], @video2.errors[:upload]
        end
    end

    test 'should return the size of video' do
        assert_equal 4000, @video2.size
    end

    test 'should return url of video thumb image' do
        @video_test = FactoryGirl.create(:video_upload_resource)
        assert_equal '/system/video_uploads/uploads/000/000/001/thumb/charlie.jpg', @video_test.medium.thumburl
    end
end
