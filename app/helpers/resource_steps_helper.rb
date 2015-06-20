##
# resource_steps_helper.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

module ResourceStepsHelper
    # create step container for the resource step-by-step form
    # sets current step active
    def step_container(step_name, css_class)
        css_class += ' step-overview'
        class_name = css_class.include?(step_name.to_s) ? css_class + ' active-step' : css_class
        content_tag(:div, class: class_name) do
            yield
        end
    end
end
