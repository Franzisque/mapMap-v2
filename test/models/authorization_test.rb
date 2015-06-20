##
# authorization_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class AuthorizationTest < ActiveSupport::TestCase
    def setup
        @auth = Authorization.new
        @user = FactoryGirl.create(:user)
    end

    def teardown
        Authorization.destroy_all
    end

    test 'must not be empty' do
        assert_not @auth.valid?
        assert @auth.errors.any?
    end

    test 'presence of provider, user and uid' do
        @auth_2 = Authorization.new(provider: 'facebook', uid: '1234567890', user: @user)
        assert @auth_2.valid?
        assert_not @auth.errors.any?
    end
end
