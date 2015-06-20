##
# resources - show.json.jbuilder
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

json.title @resource.title
json.description @resource.description
json.created_at @resource.created_at
json.views @resource.views

json.user do
    json.username @resource.user.username
    json.url url_for(profile_path(@resource.user.username))
end

json.tags @resource.tags do |tag|
    json.name tag.name
end

json.tracks @resource.tracks do |track|
    json.A track.latitude
    json.F track.longitude
end
