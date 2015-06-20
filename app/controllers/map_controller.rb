##
# map_controller.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class MapController < ApplicationController
    before_filter :store_last_location
    skip_authorization_check

    # root path
    # GET /
    # GET /tags/:tag
    def index
        @resources = Resource.tagged_with(params[:tag]) if params[:tag]
        @season_tags = Tag.season_tags
        @door_tags = Tag.door_tags
        @level_tags = Tag.level_tags
    end
end
