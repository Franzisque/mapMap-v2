##
# navigation_helper.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

module NavigationHelper
    # creates link for navigation
    # adds a 'current' css-class for the current page
    def nav_link(text, path, css_class = 'navbar-link', id = '')
        class_name = current_page?(path) ? css_class + ' current' : css_class

        link_to text, path, class: class_name, id: id
    end

    # get number of unread messages
    def unread_messages
        current_user.messages_in.where(read: false).count
    end
end
