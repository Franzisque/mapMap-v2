##
# static_helper.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

module StaticHelper
    # creates container for each team member
    def team_member(member_name, fullname, studie, work)
        content_tag(:div, class: 'team-member') do
            concat content_tag(:div, nil, id: member_name, class: 'team-picture')
            concat content_tag(:p, fullname, class: 'team-name')
            concat content_tag(:p, studie, class: 'team-studie')
            concat content_tag(:p, work, class: 'team-work')
        end
    end
end
