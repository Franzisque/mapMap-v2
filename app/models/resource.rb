##
# resource.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class Resource < ActiveRecord::Base
    belongs_to :user
    belongs_to :medium, polymorphic: true
    has_many :tracks, dependent: :destroy
    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings
    has_many :votes, dependent: :destroy
    has_many :comments, -> { order(created_at: :desc) }, dependent: :destroy
    accepts_nested_attributes_for :tracks, allow_destroy: :true
    accepts_nested_attributes_for :medium, allow_destroy: :true

    validates :title, :medium, :user, presence: true
    validates :tracks, presence: true, :if => :active?
    validates_presence_of :tags
    after_update :status_active

    scope :with_tag_names, lambda{ |name|
      where("exists (select 'x' from taggings, tags where
     resource_id = resources.id and tags.id = taggings.tag_id and tags.name = ?)", name)
    }

    scope :without_tag_names, lambda{ |name|
      where("exists (select 'x' from taggings, tags where
     resource_id = resources.id and tags.id = taggings.tag_id and tags.name != ?)", name)
    }

    # get active status of resource
    # returns true if active
    def active?
        status == 'active'
    end

    # sets resource status to 'active' if tracks are given
    def status_active
        if self.status != 'active' && self.tracks.count >= 1
            self.status = 'active'
            self.save
        end
    end

    # updates views
    def views_increment
        self.views += 1
        self.save
    end

    # query limited resources that are near to given resource
    def self.nearby_location_of(resource, difference = 0.1, limit = 5)
        if resource.active?
            lat = resource.tracks.first.latitude
            lng = resource.tracks.first.longitude

            lat1 = lat - difference
            lat2 = lat + difference
            lng1 = lng - difference
            lng2 = lng + difference

            Resource.includes(:user, :tracks).uniq.order(created_at: :desc).where(status: 'active',
                                                                                  tracks: {
                                                                                      latitude: lat1..lat2,
                                                                                      longitude: lng1..lng2
                                                                                  }).where.not(id: resource.id).limit(limit)
        else
            []
        end
    end

    # query limited resources that are similar (by tags) to given resource
    def self.similar_to(resource, limit = 5)
        if resource.tags.present?
            tag_size = resource.tags.count >= 3 ? 3 : 1
            Resource.includes(:user, taggings: :tag).uniq.order(created_at: :desc).where(status: 'active',
                                                                                         taggings: {
                                                                                             tag: resource.tags.to_a
                                                                                         }).where.not(id: resource.id).select{ |item| (resource.tags & item.tags).size >= tag_size }.first(limit)
        else
            []
        end
    end

    # query limited resources that contains the given tags and/or username
    def self.tagged_with_tags(tags_array, username, limit = 50)
        if username.present?
            resources = Resource.joins(:user).where(status: 'active', users: {username: username}).includes([:medium, :tracks, :tags, :taggings]).uniq.order(created_at: :desc).limit(limit)
        else
            resources = Resource.includes([:user, :medium, :tracks, :tags, :taggings]).uniq.where(status: 'active').order(created_at: :desc).limit(limit)
        end

        tags_array.each do |tag_name|
            resources = resources.with_tag_names(tag_name)
        end

        resources
    end

    # returns resources with a given tag
    def self.tagged_with(name)
        begin
            Tag.find_by_name!(name).resources
        rescue Exception
        end
    end

    def self.tag_counts
        Tag.select("tags.*, count(taggings.tag_id) as count").joins(:taggings).group("taggings.tag_id")
    end

    # get tags (except of main tags)
    # returns sring with tag-names
    def tag_list
        tag_list_array = self.tags.to_a
        tag_list_array.delete_if { |tag| Tag.main_tags.include?(tag.name) }
        tag_list_array.map(&:name).join(", ")
    end

    # set tags
    # STRING names
    def tag_list=(names)
        tag_names = names.split(",").map! {|tag| tag.downcase.strip.gsub(/[^\w]/,'_') }
        tags_array = []
        tag_names.each do |name|
            tags_array  << Tag.where(name: name).first_or_create
        end
        self.tags = tags_array
    end

    # get season tags
    def season_tags
        season_tags_ids ||= self.tags.where("name IN (?)", Tag::SEASON_TAGS).map(&:id)
    end

    # set season tags
    def season_tags=(tag_id_array)
        tag_id_array.each do |id|
            self.tags << Tag.find(id.to_i) unless id.blank?
        end
    end

    # get level tags
    def level_tags
        level_tags_ids ||= self.tags.where("name IN (?)", Tag::LEVEL_TAGS).map(&:id)
    end

    # set level tags
    def level_tags=(tag_id_array)
        tag_id_array.each do |id|
            self.tags << Tag.find(id.to_i) unless id.blank?
        end
    end

    # get door tags
    def door_tags
        door_tags_ids ||= self.tags.where("name IN (?)", Tag::DOOR_TAGS).map(&:id)
    end

    # set door tags
    def door_tags=(tag_id_array)
        tag_id_array.each do |id|
            self.tags << Tag.find(id.to_i) unless id.blank?
        end
    end

    # get up votes
    def up_votes
        self.votes.where(value: 1).count
    end

    # get down votes
    def down_votes
        self.votes.where(value: -1).count
    end

    # create/update vote of given user
    def update_or_create_vote(value, user)
        vote = self.votes.find_by user: user
        if vote
            if vote.value == 0
                vote.value = value
            else
                vote.value = vote.value == value ? value : 0
            end
            vote.save
        else
            self.votes.create!(value: value, user: user)
        end
    end
end
