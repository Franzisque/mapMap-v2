##
# comment_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
    def setup
        @resource = FactoryGirl.create(:video_link_resource)
        @comment = Comment.create(text: 'test', user: @resource.user, resource: @resource)
    end

    def teardown
        Resource.destroy_all
    end

    test 'comment must not be empty' do
        @comment = Comment.new
        assert_not @comment.valid?
    end

    test 'presence of user, resource and text' do
        assert @comment.valid?
        assert_not @comment.errors.any?
    end

    test 'no user' do
        @comment.user = nil
        assert_not @comment.valid?
        assert @comment.errors[:user].any?
    end

    test 'no resource' do
        @comment.resource = nil
        assert_not @comment.valid?
        assert @comment.errors[:resource].any?
    end

    test 'no text' do
        @comment.text = nil
        assert_not @comment.valid?
        assert @comment.errors[:text].any?
    end

    test 'text length to short' do
        @comment.text = ' '
        assert_not @comment.valid?
        assert @comment.errors[:text].any?
    end
end
