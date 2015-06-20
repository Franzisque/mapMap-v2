##
# user_helper.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

module UsersHelper
    # returns a link for media buttons on user profile view
    # selects if link is currently active
    def user_resource_link(text, path, css_class = 'media-button')
        if params[:medium]
            css_class += ' active' if text.downcase.eql?(params[:medium])
        elsif text.eql?('All')
            css_class += ' active'
        end
        link_to text, path, class: css_class, remote: true
    end

    # returns the name of the user with Mr. or Ms. if gender is given
    def display_name(gender, name)
        if gender.present?
            title = gender == 'male' ? 'Mr. ' : 'Ms. '
            name.insert(0, title)
        end

        name
    end
end
