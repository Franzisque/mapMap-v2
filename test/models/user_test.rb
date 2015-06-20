##
# user_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class UserTest < ActiveSupport::TestCase
    def setup
        @admin = FactoryGirl.create(:admin)
        @user = FactoryGirl.create(:user)
        @user2 = FactoryGirl.create(:user_without_role)
        @user3 = FactoryGirl.create(:user_birth)
        @fb_user = FactoryGirl.create(:user_facebook)
    end

    def teardown
        User.destroy_all
    end

    # Validations test
    test 'username validation' do
        @testuser = User.new(email: 'testuser@mail.com', password: '12345678', password_confirmation: '12345678', username: ' ')
        assert_not @testuser.save

        @testuser.username = 'pi'
        assert @testuser.save
    end

    test 'gender validtion' do
        @user.gender = 'male'
        assert @user.save, 'User should be allowed to have male as gender'

        @user.gender = 'animal'
        assert_not @user.save, "User should not be allowed to have 'animal' as gender"

        @user.gender = nil
        assert @user.save, 'User should be allowed to have nil'
    end

    test 'day of birth validation' do
        (1..31).to_a.unshift(nil).each do |n|
            @user.birth_day = n
            assert @user.save, "User should be allowed to have #{n} as day"
        end

        @user.birth_day = 0
        assert_not @user.save
    end

    test 'month of birth validation' do
        (1..12).to_a.unshift(nil).each do |n|
            @user.birth_month = n
            assert @user.save, "User should be allowed to have #{n} as month"
        end

        @user.birth_month = 0
        assert_not @user.save
    end

    test 'year of birth validation' do
        @user.birth_year = 2000
        assert @user.save, 'User should be allowed to have 2000 as year'

        @user.birth_year = 1914
        assert_not @user.save
    end

    test 'firstname validation' do
        firstname_good = ['tester', 'tester yo', 'tester-yo', nil, ' ']
        firstname_bad = [' a']

        firstname_good.each do |name|
            @user.firstname = name
            assert @user.save, "'#{name}' should be valid"
        end

        firstname_bad.each do |name|
            @user.firstname = name
            assert_not @user.save, "'#{name}' should not be valid"
        end
    end

    test 'lastname validation' do
        lastname_good = ['tester', 'tester yo', 'tester-yo', nil, ' ']
        lastname_bad = [' a']

        lastname_good.each do |name|
            @user.lastname = name
            assert @user.save, "'#{name}' should be valid"
        end

        lastname_bad.each do |name|
            @user.lastname = name
            assert_not @user.save, "'#{name}' should not be valid"
        end
    end

    # Method tests
    test 'get users birthday' do
        assert_nil @user2.birthday, 'Birthday should be nil - no birthday data set'
        assert_equal '28. October 1990', @admin.birthday, 'Birthday should be: 28. October 1990'
        assert_equal '1990', @user.birthday, 'Birthday should be: 1990'
        assert_equal '28. October', @user3.birthday, 'Birthday should be: 28. October'
    end

    test 'get users fullname' do
        assert_equal 'max mustermann', @admin.name
        assert_nil @user.name, 'Fullname should be nil if not set'
    end

    test 'user provider set' do
        assert_not @admin.provider_set?
        assert @fb_user.provider_set?
    end

    test 'should create avatar after user is created' do
        assert_equal 1, @user.avatars.count
        assert_equal 'gravatar', @user.avatars.first.provider
    end

    test 'get gravatar image url' do
        assert_match /^https:\/\/secure\.gravatar\.com.+/, @user.image_url
    end

    test 'should get active avatar' do
        assert_not_nil @user.selected_avatar
    end

    test 'should get id of active avatar' do
        assert_instance_of Fixnum, @user.avatar
    end

    test 'should set new avatar' do
        @fb_avatar = @fb_user.avatars.create(provider: 'facebook')
        assert_equal 'gravatar', @fb_user.selected_avatar.provider
        assert_equal 'facebook', @fb_user.avatars.last.provider

        @fb_user.avatar = @fb_avatar.id
        @fb_user.reload
        assert_equal 'facebook', @fb_user.selected_avatar.provider
    end

    test 'should get used memory size - no resource' do
        assert_equal 0, @user.size_of_uploads
    end
end
