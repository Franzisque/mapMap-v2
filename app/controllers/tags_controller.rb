##
# tags_controller.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class TagsController < ApplicationController
    # GET /tags.json
    def index
        @tags = Tag.all
    end
end
