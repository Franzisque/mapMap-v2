##
# static_controller.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class StaticController < ApplicationController
    before_filter :store_last_location

    # GET /about
    def about
    end

    # GET /imprint
    def imprint
    end
end
