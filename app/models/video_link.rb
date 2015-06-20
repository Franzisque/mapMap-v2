##
# video_link.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'open-uri'

class VideoLink < ActiveRecord::Base
    has_one :resource, as: :medium, dependent: :destroy
    validates :link, presence: true, video_link: true
    before_create :set_provider, :set_video_id, :set_thumb_path

    PROVIDERS = %w(youtube vimeo)

    # set the thumb url of the given provider
    # calls the method to get the thumb url of the given provider
    def set_thumb_path
        self.thumb_path = send("#{provider}_thumb")
    end

    # get the thumb url of the video
    def thumburl
        thumb_path
    end

    # get the size of the provider video
    def size
        0
    end

    protected

    # set the provider in provider attribute
    def set_provider
        PROVIDERS.each do |name|
            regex_string = PROVIDERS.first.eql?(name) ? name[0..-3] : name
            self.provider = name if link =~ /#{regex_string}/
        end
    end

    # calls the method for setting the video id of the given provider
    def set_video_id
        send("#{provider}_video_id")
    end

    # set youtube video id in vid attribute
    def youtube_video_id
        video_id = link.match(/\?v=/) ? link.split('?v=')[1] : link.split('/').last
        video_id = video_id.split('&')[0] if video_id =~ /&/
        self.vid = video_id
    end

    # set vimeo video id in vid attribute
    def vimeo_video_id
        self.vid = link.split('/').last
    end

    # get the thumb url for youtube video
    def youtube_thumb
        "http://img.youtube.com/vi/#{vid}/mqdefault.jpg" # img size: 320x180
    end

    # get the thumb url for vimeo video
    def vimeo_thumb
        vimeo_json_url = "http://vimeo.com/api/v2/video/#{vid}.json"
        JSON.parse(open(vimeo_json_url).read).first['thumbnail_large'] # img size: 640x
      rescue => e
          raise e
    end
end
