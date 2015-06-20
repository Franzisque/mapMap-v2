##
# album_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
    def setup
        @album = Album.new
    end

    def teardown
        Album.destroy_all
        Image.destroy_all
    end

    test 'album must not be empty' do
        assert_not @album.valid?
        assert @album.errors.any?
    end

    test 'album must have at least one image' do
        @album2 = FactoryGirl.build(:album)
        assert @album2.valid?
        assert @album2.save
        assert_equal 2, @album2.images.count

        @album2.images.first.destroy!
        assert_equal 1, @album2.images.count

        @album2.images.first.destroy!
        assert_equal 1, @album2.images.count
    end

    test 'should get total memory usage size of images' do
        @album2 = FactoryGirl.build(:album)
        assert_equal 2_330_940.0, @album2.size
    end

    test 'should get thumb url of album' do
        @album2 = FactoryGirl.build(:album)
        assert_equal '/system/images/pics//medium/charlie_masche.jpg', @album2.thumburl
    end
end
