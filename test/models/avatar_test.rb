##
# avatar_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class AvatarTest < ActiveSupport::TestCase
    def setup
        @avatar = Avatar.new
        @user = FactoryGirl.create(:user)
    end

    def teardown
        User.destroy_all
        Avatar.destroy_all
    end

    # validations
    test 'avatar must not be empty' do
        assert_not @avatar.valid?
    end

    test 'presence of provider and user' do
        @avatar.provider = 'facebook'
        @avatar.user = @user
        assert @avatar.valid?
    end

    test 'valid providers' do
        good = %w(gravatar facebook)
        @avatar.user = @user

        good.each do |prov|
            @avatar.provider = prov
            assert @avatar.valid?, "#{prov} should be a valid provider"
        end
    end

    test 'invalid providers' do
        bad = %w(youtube vimeo)
        @avatar.user = @user

        bad.each do |prov|
            @avatar.provider = prov
            assert_not @avatar.valid?, "#{prov} should not be a valid provider"
            assert @avatar.errors[:provider].any?
        end
    end

    # methods
    test 'should set path for facebook when created' do
        @fb_user = FactoryGirl.create(:user_facebook)

        @avatar.user = @fb_user
        @avatar.provider = 'facebook'
        assert @avatar.save
        assert_equal 'http://graph.facebook.com/12345678901234567/picture', @avatar.path
    end

    test 'should set path for gravatar when created' do
        @avatar.user = @user
        @avatar.provider = 'gravatar'
        assert @avatar.save
        assert_match /\Ahttps:\/\/secure\.gravatar\.com\/avatar\/[a-z0-9]{22,}\.png\z/, @avatar.path
    end

    test 'should get facebook image url with a given size' do
        @fb_user = FactoryGirl.create(:user_facebook)
        @avatar.user = @fb_user
        @avatar.provider = 'facebook'
        assert @avatar.save

        assert_equal 'http://graph.facebook.com/12345678901234567/picture?type=large', @avatar.url('large')
        assert_equal 'http://graph.facebook.com/12345678901234567/picture?type=normal', @avatar.url('normal')
        assert_equal 'http://graph.facebook.com/12345678901234567/picture?type=small', @avatar.url('small')
    end

    test 'should get gravatar image url with a given size' do
        @avatar.user = @user
        @avatar.provider = 'gravatar'
        assert @avatar.save

        assert_match /\Ahttps:\/\/secure\.gravatar\.com\/avatar\/[a-z0-9]{22,}\.png\?s=200\z/, @avatar.url('large')
        assert_match /\Ahttps:\/\/secure\.gravatar\.com\/avatar\/[a-z0-9]{22,}\.png\?s=100\z/, @avatar.url('normal')
        assert_match /\Ahttps:\/\/secure\.gravatar\.com\/avatar\/[a-z0-9]{22,}\.png\?s=50\z/, @avatar.url('small')
    end

    test 'should put last created avatar to be not active' do
        @fb_user = FactoryGirl.create(:user_facebook)
        @avatar.user = @fb_user
        @avatar.provider = 'facebook'
        assert @avatar.save

        assert_not @avatar.is_active
    end

    test 'should put first created avatar to be active' do
        assert @user.avatars.first.is_active
    end
end
