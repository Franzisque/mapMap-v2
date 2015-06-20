##
# errors_controller.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class ErrorsController < ApplicationController
    # shows error pages
    # GET /404
    # GET /422
    # GET /500
    def show
        render error_code.to_s, status: error_code
    end

    private

    def error_code
        params[:code] || 404
    end
end
