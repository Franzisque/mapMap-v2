##
# video_link_validator.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class VideoLinkValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        unless validate_youtube_link(value) || validate_vimeo_link(value)
            record.errors[attribute] << (options[:message] || 'is not a valid youtube/vimeo url')
        end
    end

    def validate_youtube_link(value)
        value =~ /^(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})/
    end

    def validate_vimeo_link(value)
        value =~ /^(?:https?:\/\/)?(?:www\.)?vimeo\.com\/(.+\/)?(\d{8,10})/
    end
end
