##
# user - index.json.jbuilder
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

json.data @users do |user|
    json.name user.username
    json.allow user.allowcontact
    json.current user == current_user
end
