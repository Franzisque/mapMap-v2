##
# user_controller.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class UserController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :user_not_found
    before_filter :store_last_location
    before_action :set_user, only: [:show]

    # get all usernames
    # GET /users.json
    def index
        @users = User.all
    end

    # get user profile
    # GET user/:username
    def show
        case params[:medium]
        when 'videos' then @resources = @user.resources.where(medium_type: %w(VideoUpload VideoLink))
        when 'images' then @resources = @user.resources.where(medium_type: 'Album')
        else
            @resources = @user.resources
        end

        @resources = @resources.where(status: 'active') unless @user.eql?(current_user)
    end

    private

    # find user by username
    # include country, avatar and resources
    def set_user
        @user = User.includes(:country, :avatars, resources: :medium).find_by_username!(params[:username])
    end

    def user_not_found
        redirect_to root_path, alert: 'User not found'
    end
end
