##
# resources_helper.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

module ResourcesHelper
    # create image for album if album images empty
    def setup_album(album)
        album.images ||= Image.new
        album
    end

    # build image for another image upload to update album
    def update_album(album)
        album.images.build
        album
    end

    # create and return iframe for youtube/vimeo videos
    def embed(video)
        case video.provider
        when 'youtube' then source = "http://www.youtube.com/embed/#{video.vid}"
        when 'vimeo' then source = "http://player.vimeo.com/video/#{video.vid}"
        else
            source = 'http://www.youtube.com/embed/MJbTjBLEKBU'
        end

        content_tag(:iframe, nil, src: source)
    end
end
