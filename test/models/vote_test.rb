##
# vote_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class VoteTest < ActiveSupport::TestCase
    def setup
        @user = FactoryGirl.create(:user)
        @resource = FactoryGirl.create(:video_link_resource)
        @vote = Vote.create(resource: @resource, user: @user, value: 1)
    end

    def teardown
        User.destroy_all
        Resource.destroy_all
        Vote.destroy_all
    end

    test 'vote must not be empty' do
        @vote2 = Vote.new
        assert @vote2.invalid?
        assert @vote2.errors.any?
    end

    test 'validate vote values' do
        good = [1, 0, -1]
        bad = [2, -2, 2.1]

        good.each do |val|
            @vote.value = val
            assert @vote.valid?, "#{val} should be a valid value"
        end

        bad.each do |bval|
            @vote.value = bval
            assert @vote.invalid?, "#{bval} should not be a valid value"
            assert @vote.errors[:value].any?
        end
    end

    test 'user can only vote once for each resource' do
        assert @vote.valid?

        @vote3 = Vote.new(resource: @resource, user: @user, value: -1)
        assert_not @vote3.valid?
        assert @vote3.errors[:resource].any?
    end
end
