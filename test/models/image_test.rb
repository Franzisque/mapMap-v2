##
# image_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class ImageTest < ActiveSupport::TestCase
    def setup
        @image = Image.new
        @image2 = FactoryGirl.build(:image)
    end

    def teardown
        Image.destroy_all
    end

    test 'image must not be empty' do
        assert @image.invalid?
        assert @image.errors[:pic].any?
    end

    test 'valid image file name' do
        file_names = %w(test.jpg test.jpeg test.png test.gif test.JPG)

        file_names.each do |name|
            @image2.pic_file_name = name
            assert @image2.valid?, "#{name} should be valid"
        end
    end

    test 'invalid image file name' do
        invalid_names = %w(test.JpG test.pdf test.mp3 test.mov test.mp4)

        invalid_names.each do |name|
            @image2.pic_file_name = name
            assert @image2.invalid?, "#{name} should not be valid"
        end
    end

    test 'valid image content type' do
        content_types = %w(image/jpeg image/jpg image/png image/gif)

        content_types.each do |type|
            @image2.pic_content_type = type
            assert @image2.valid?, "#{type} should be valid"
        end
    end

    test 'invalid image content type' do
        invalid_content_types = %w(video/mp4 audio/ogg application/ogg application/pdf)

        invalid_content_types.each do |type|
            @image2.pic_content_type = type
            assert @image2.invalid?, "#{type} should not be valid"
        end
    end

    test 'valid image dimension' do
        assert @image2.valid?
        assert_not @image2.errors.any?
    end
end
