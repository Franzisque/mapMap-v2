##
# tag.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class Tag < ActiveRecord::Base
    has_many :taggings, dependent: :destroy
    has_many :resources, through: :taggings

    validates :name, presence: true
    validates :name, format: { with: /\A([a-zA-Z0-9_]+)\z/, message: "can only have letters, numbers and '_'" }

    BAD_TAGS = %w(dick fuck gay pussy asshole xxx porno)
    SEASON_TAGS = %w(summer winter)
    LEVEL_TAGS = %w(rookie advanced pro)
    DOOR_TAGS = %w(indoor outdoor)

    before_save :make_tag_names_downcase

    # get all season tags
    def self.season_tags
        @season_tags ||= where('name IN (?)', SEASON_TAGS)
    end

    # get all level tags
    def self.level_tags
        @level_tags ||= where('name IN (?)', LEVEL_TAGS)
    end

    # get all door tags
    def self.door_tags
        @door_tags ||= where('name IN (?)', DOOR_TAGS)
    end

    # get all main tags
    def self.main_tags
        @main_tags ||= SEASON_TAGS + LEVEL_TAGS + DOOR_TAGS
    end

    # check if given tag name is a main tag
    def self.is_custom_tag(tag)
        tag = Tag.find_by_name(tag)
        return false unless Tag.all.include? tag
        !Tag.main_tags.include? tag.name
    end

    private

    # make tag name downcase
    def make_tag_names_downcase
        name.downcase!
    end
end
