##
# application_helper.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

module ApplicationHelper
    # returns partial string for 'form fields' of given object
    def fields_partial_for(o)
        "#{o.class.name.underscore}s/fields"
    end

    # returns partial string for 'show' of given object
    def show_partial_for(o)
        "#{o.class.name.underscore}s/show"
    end

    # returns partial string for 'details' of given object
    def details_partial_for(o)
        "#{o.class.name.underscore}s/details"
    end

    # returns partial string for 'index' of given object
    def index_partial_for(o)
        "#{o.class.name.underscore}s/index"
    end

    # returns a short version of a text
    # max_length (int) => max number of characters
    def short_text(text, max_length)
        short = text
        if text.present? && text.length > max_length
            short_array = text.slice(0, max_length).split(' ')
            short_array.pop
            short = short_array.join(' ') + ' ...'
        end
        short
    end

    # replaces '\n' with a break tag for displaying breaks in text
    def text_block(text)
        h(text).gsub(/\n/, '<br/>').html_safe
    end

    # returns time difference in words
    def set_time_difference(time)
        time_difference = time_ago_in_words(time)
        time_difference += ' ago'
    end
end
