##
# track_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class TrackTest < ActiveSupport::TestCase
    def setup
        @empty_track = Track.new
        @track = FactoryGirl.create(:track)
    end

    def teardown
        Track.destroy_all
    end

    test 'track must not be empty' do
        assert @empty_track.invalid?
        assert @empty_track.errors.any?

        assert @track.valid?
        assert_not @track.errors.any?
    end

    test 'presence of latitude' do
        assert @empty_track.invalid?
        assert @empty_track.errors[:latitude].any?, 'latitude is not given, error should be thrown'

        assert @track.valid?
        assert_not @track.errors[:latitude].any?, 'latitude given, should not throw error'
    end

    test 'presence of longitude' do
        assert @empty_track.invalid?
        assert @empty_track.errors[:longitude].any?, 'longitude is not given, error should be thrown'

        assert @track.valid?
        assert_not @track.errors[:longitude].any?, 'longitude given, should not throw error'
    end

    test 'numerical value of latitude' do
        @empty_track.longitude = 65

        latitude_good = [84.9, -84.9]
        latitude_bad = [-86.9, 85.9]

        latitude_bad.each do |value|
            @empty_track.latitude = value
            assert @empty_track.invalid?
            assert @empty_track.errors[:latitude].any?, "latitudes value ( #{value} ) is bad, error should be thrown"
        end

        latitude_good.each do |value|
            @empty_track.latitude = value
            assert @empty_track.valid?
            assert_not @empty_track.errors[:latitude].any?, "latitudes value ( #{value} ) is good, error should not be thrown"
        end
    end

    test 'numerical value of longitude' do
        @empty_track.latitude = 65

        longitude_good = [179.9, -179.9]
        longitude_bad = [-180.9, 180.9]

        longitude_bad.each do |value|
            @empty_track.longitude = value
            assert @empty_track.invalid?
            assert @empty_track.errors[:longitude].any?, "longitude value ( #{value} ) is bad, error should be thrown"
        end

        longitude_good.each do |value|
            @empty_track.longitude = value
            assert @empty_track.valid?
            assert_not @empty_track.errors[:longitude].any?, "longitude value ( #{value} ) is good, error should not be thrown"
        end
    end
end
