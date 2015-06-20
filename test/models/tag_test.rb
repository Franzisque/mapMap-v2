##
# tag_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class TagTest < ActiveSupport::TestCase
    def setup
        Tag.main_tags.each do |name|
            Tag.where(name: name).first_or_create
        end
    end

    def teardown
        Tag.destroy_all
    end

    test 'tag must not be empty' do
        @tag_empty = Tag.new
        assert @tag_empty.invalid?
        assert @tag_empty.errors[:name].any?
    end

    test 'should allow numbers in tag name' do
        @tag1 = Tag.new(name: 'test123')
        assert @tag1.valid?
        assert_not @tag1.errors[:name].any?
    end

    test 'should not allow whitespaces in tag name' do
        @tag1 = Tag.new(name: 'test 123')
        assert @tag1.invalid?
        assert @tag1.errors[:name].any?
    end

    test 'should allow letters and underscore in tag name' do
        @tag2 = Tag.new(name: 'test_this')
        assert @tag2.valid?
        assert_not @tag2.errors[:name].any?
    end

    test 'should downcase name when saved' do
        @tag3 = Tag.new(name: 'Winter')
        assert @tag3.save
        assert_equal 'winter', @tag3.name
    end

    test 'should find all season tags' do
        assert_equal 2, Tag.season_tags.count
        Tag.season_tags.each do |tag|
            assert %w(summer winter).include?(tag.name)
        end
    end

    test 'should find all door tags' do
        assert_equal 2, Tag.door_tags.count
        Tag.door_tags.each do |tag|
            assert %w(indoor outdoor).include?(tag.name)
        end
    end

    test 'should find all level tags' do
        assert_equal 3, Tag.level_tags.count
        Tag.level_tags.each do |tag|
            assert %w(rookie advanced pro).include?(tag.name)
        end
    end

    test 'should return all main_tags as string array' do
        assert_equal %w(summer winter rookie advanced pro indoor outdoor), Tag.main_tags
    end
end
