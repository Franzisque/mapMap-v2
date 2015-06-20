##
# resource_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
    def setup
        @user = FactoryGirl.create(:user)
        @video_link = FactoryGirl.create(:video_link_youtube)
        @resource = Resource.new
        @track = Track.create(latitude: 13.00, longitude: 14.00)
        @resource3 = FactoryGirl.create(:video_link_resource)

        Tag.main_tags.each do |name|
            Tag.where(name: name).first_or_create
        end

        @resource2 = Resource.new(
            title: 'test',
            description: 'description',
            medium: @video_link,
            user: @user,
            tags: [Tag.find_by_name('outdoor')]
        )
    end

    def teardown
        Resource.destroy_all
        User.destroy_all
        VideoLink.destroy_all
        Tag.destroy_all
        Vote.destroy_all
    end

    # validations
    test 'resource must not be empty' do
        assert @resource.invalid?
        assert @resource.errors.any?

        assert @resource2.valid?
        assert_not @resource2.errors.any?
    end

    test 'presence of title' do
        assert @resource.invalid?
        assert @resource.errors[:title].any?, 'title is not given, error should be thrown'

        assert @resource2.valid?
        assert_not @resource2.errors[:title].any?, 'title given, should not throw error'
    end

    test 'presence of medium' do
        assert_not @resource.valid?
        assert @resource.errors[:medium].any?, 'medium not given, error should be thrown'

        assert @resource2.valid?
        assert_not @resource2.errors[:medium].any?, 'medium is given, error should not be thrown'
    end

    test 'presence of user' do
        assert_not @resource.valid?
        assert @resource.errors[:user].any?, 'user not given, error should be thrown'

        assert @resource2.valid?
        assert_not @resource2.errors[:user].any?, 'user is given, error should not be thrown'
    end

    # methods
    test 'active state of resource' do
        assert_not @resource2.active?

        @resource2.status = 'active'
        assert @resource2.active?
    end

    test 'view increment' do
        assert_equal 0, @resource2.views
        @resource2.views_increment
        assert_equal 1, @resource2.views
    end

    # tags
    test 'should find resource with a given tag' do
        @tag = FactoryGirl.create(:tag)
        @resource2.tag_list = @tag.name
        @resource2.save

        assert_equal @resource2, Resource.tagged_with(@tag.name).first
    end

    test 'should find or create tag associated to resource' do
        @resource2.tag_list = 'mountain, summer, winter, biking'
        @resource2.save

        assert_equal 4, @resource2.tags.count
    end

    test 'should get tags with number of associated resources' do
        Tag.destroy_all
        @resource2.tag_list = 'mountain, biking'
        assert @resource2.save
        @resource3.tag_list = 'biking'
        assert @resource3.save

        tags = Resource.tag_counts
        assert_equal 2, tags.sort_by(&:count).last.count
        assert_equal 'mountain', tags.first.name
    end

    test 'should set and get season tag' do
        @season_tag = Tag.where(name: 'summer').first_or_create
        @resource3.tags = []
        @resource3.season_tags = [@season_tag.id]
        assert @resource3.save
        assert_equal 1, @resource3.season_tags.count
        assert_equal @resource3.season_tags, [@season_tag.id]
    end

    test 'should set and get level tag' do
        @level_tag = Tag.where(name: 'rookie').first_or_create
        @resource3.tags = []
        @resource3.level_tags = ["#{@level_tag.id}"]
        assert @resource3.save
        assert_equal 1, @resource3.level_tags.count
        assert_equal @resource3.level_tags, [@level_tag.id]
    end

    test 'should set and get door tag' do
        @door_tag = Tag.where(name: 'outdoor').first_or_create
        @resource3.tags = []
        @resource3.door_tags = [@door_tag.id]
        assert @resource3.save

        assert_equal 1, @resource3.door_tags.count
        assert_equal @resource3.door_tags, [@door_tag.id]
    end

    # votes
    test 'should find all associated up votes' do
        assert_equal 0, @resource3.up_votes

        @resource3.votes.create(value: 1, user: @user)
        assert_equal 1, @resource3.up_votes
    end

    test 'should find all associated down votes' do
        assert_equal 0, @resource3.down_votes

        @resource3.votes.create(value: -1, user: @user)
        assert_equal 1, @resource3.down_votes
    end

    test 'should create new vote for given user' do
        assert_equal 0, @resource3.votes.count

        @resource3.update_or_create_vote(-1, @user)
        assert_equal 1, @resource3.votes.count
    end

    test 'should update vote for given user to be zero' do
        assert_equal 0, @resource3.votes.count

        @resource3.update_or_create_vote(-1, @user)
        @resource3.update_or_create_vote(1, @user)
        assert_equal 1, @resource3.votes.count
        assert_equal 0, @resource3.votes.first.value
    end

    test 'should update vote for given user on second change' do
        assert_equal 0, @resource3.votes.count

        @resource3.update_or_create_vote(-1, @user)
        @resource3.update_or_create_vote(1, @user)
        @resource3.update_or_create_vote(1, @user)
        assert_equal 1, @resource3.votes.count
        assert_equal 1, @resource3.votes.first.value
    end

    test 'should put resource state to active if tracks are given' do
        assert @resource2.save
        assert_not_equal 'active', @resource2.status
        assert @resource2.update!(tracks: [@track])
        assert_equal 'active', @resource2.status
    end

    test 'should find nearby resources' do
        @resource2.update!(status: 'active', tracks: [@track])
        assert @resource2.active?, 'resource not active'
        @resource4 = Resource.create!(
            title: 'test again',
            description: 'description again',
            medium: @video_link,
            user: @user,
            status: 'active',
            tags: [Tag.find_by_name('outdoor')],
            tracks: [Track.new(latitude: 13.0, longitude: 14.0)]
        )
        assert @resource4.active?
        assert_equal 1, Resource.nearby_location_of(@resource2).count
        assert_equal @resource4, Resource.nearby_location_of(@resource2).first
    end

    test 'should find similar resources' do
        assert @resource2.update!(status: 'active', tracks: [@track])
        assert @resource3.update!(tracks: [@track])

        assert_equal 'active', @resource3.status
        assert_equal 'active', @resource2.status
        assert_equal 'outdoor', @resource3.tags.last.name
        assert_equal 'outdoor', @resource2.tags.first.name

        assert_not_nil Resource.similar_to(@resource2)
        assert_equal 1, Resource.similar_to(@resource3).count
    end

    test 'should find resources with given tags' do
        assert @resource2.update!(status: 'active', tracks: [@track])
        assert @resource3.update!(tracks: [@track])

        assert_equal 1, Resource.tagged_with_tags(%w(outdoor summer), nil).count
        assert_equal 2, Resource.tagged_with_tags(['outdoor'], nil).count
    end

    test 'should find resources with given username' do
        assert @resource2.update!(status: 'active', tracks: [@track])
        assert @resource3.update!(tracks: [@track])

        assert_equal 1, Resource.tagged_with_tags(%w(outdoor summer), @resource3.user.username).count
        assert_equal @resource2, Resource.tagged_with_tags(['outdoor'], @user.username).first
    end
end
