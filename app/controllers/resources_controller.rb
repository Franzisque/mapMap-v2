##
# resources_controller.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class ResourcesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found
    before_action :set_resource, only: [:edit, :update, :destroy, :vote, :status]
    before_filter :store_last_location
    before_filter :authenticate_user!, except: [:show, :index, :status]
    load_and_authorize_resource except: [:show, :index, :vote, :status]

    # GET /resources
    def index
        if params[:tag]
            @resources = Resource.tagged_with(params[:tag])

        elsif params[:filter]
            @resources = Resource.tagged_with_tags(filter_tags_array, params[:username])
        else
            @resources = Resource.order(created_at: :desc)
        end
    end

    # GET /resources/1
    def show
        @resource = Resource.includes(user: :avatars, comments: :user, taggings: :tag).find(params[:id])
        add_view
        @nearby_resources = Resource.nearby_location_of(@resource)
        @similar_resources = Resource.similar_to(@resource)
        @comment = Comment.new
    end

    # GET /resources/new
    # redirects to resource_steps
    def new
        redirect_to resource_steps_path
    end

    # GET /resources/1/edit
    def edit
        set_main_tags
    end

    # PATCH/PUT /resources/1
    # PATCH/PUT /resources/1.json
    def update
        if medium_params_set?
            @resource.medium.update(medium_attributes_params)
            medium_params_delete!
        end

        @resource.tracks.destroy_all if params[:resource][:tracks_attributes]

        respond_to do |format|
            if @resource.update(resource_params)
                format.html { redirect_to medium_path(@resource), notice: 'Media was successfully updated.' }
                format.json { head :no_content }
            else
                set_main_tags
                format.html { render action: 'edit' }
                format.json { render json: @resource.errors.full_messages,  status: :unprocessable_entity }
            end
        end
    end

    # destroys resource and all associations including uploaded files (videos/images)
    # DELETE /resources/1
    # DELETE /resources/1.js
    # DELETE /resources/1.json
    def destroy
        @resource.medium.destroy
        respond_to do |format|
            format.html { redirect_to profile_path(current_user.username) }
            format.js
            format.json { head :no_content }
        end
    end

    # POST /resources/1/vote.js
    def vote
        value = params[:vote] == 'up' ? 1 : -1
        respond_to do |format|
            @resource.update_or_create_vote(value, current_user)
            format.html { redirect_to :back, notice: 'Thank you for voting' }
            format.js {}
        end
    end

    # GET /resources/1/status.json
    # for video upload
    def status
    end

    private

    # Params whitelist
    def resource_params
        params.require(:resource).permit(
            :id,
            :title,
            :tag_list,
            :season_tag,
            :door_tag,
            :description,
            :vote,
            :distance,
            :altitude_up,
            :altitude_down,
            :medium_type,
            medium_attributes: [:upload, :link, images_attributes: [:id, :_destroy, :pic]],
            tracks_attributes: [:latitude, :longitude, :order, :id, :_destroy],
            level_tags: [],
            season_tags: [],
            door_tags: []
        )
    end

    def set_resource
        @resource = Resource.find(params[:id])
    end

    def set_main_tags
        @season_tags = Tag.season_tags
        @door_tags = Tag.door_tags
        @level_tags = Tag.level_tags
    end

    # specify if medium is given in params hash
    def medium_params_set?
        params[:resource][:medium_attributes] && params[:resource][:medium_type]
    end

    # gets medium attributes from params hash
    def medium_attributes_params
        resource_params[:medium_attributes]
    end

    # deletes medium from params hash
    def medium_params_delete!
        params[:resource].delete(:medium_attributes)
        params[:resource].delete(:medium_type)
    end

    # save viewed resource id in cookie
    def save_media_in_cookie
        id = @resource.id
        if cookies[:viewed_media]
            cookies[:viewed_media] += ',' + id.to_s unless viewed_media.include?(id)
        else
            cookies[:viewed_media] = id.to_s
        end
    end

    # get resource ids from cookie
    def viewed_media
        cookies[:viewed_media] ? cookies[:viewed_media].split(',') : []
    end

    # increment resource view unless user has seen it before or is the owner
    def add_view
        if !@resource.user.eql?(current_user) && !viewed_media.include?(@resource.id.to_s)
            save_media_in_cookie
            @resource.views_increment
        end
    end

    # redirect to root path if media was not found
    def resource_not_found
        redirect_to root_path, alert: 'Media not found'
    end

    # creates array of tag names
    # used for filtering resources
    def filter_tags_array
        tags_array = params[:filter][:season_tags] + params[:filter][:door_tags] + params[:filter][:level_tags]
        tags_array = tags_array.reject(&:empty?)
        params[:tag_list].split(',').map do |name|
            tags_array << name
        end
        tags_array
    end
end
