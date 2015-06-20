##
# devise_helper.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

module DeviseHelper
    # override devise error message
    def devise_error_messages!
        return '' if resource.errors.empty?

        messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
        sentence = I18n.t('errors.messages.not_saved',
                          count: resource.errors.count,
                          resource: resource.class.model_name.human.downcase)

        html = <<-HTML
            <div id="error_explanation" class="error_messages">
                <h3>#{sentence}</h3>
                <ul>#{messages}</ul>
            </div>
        HTML

        html.html_safe
    end

    def devise_error_messages?
        resource.errors.empty? ? false : true
    end
end
