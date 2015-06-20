##
# resource_steps_controller.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class ResourceStepsController < ApplicationController
    include Wicked::Wizard
    before_filter :store_last_location
    before_filter :authenticate_user!
    before_action :set_resource, only: [:update]

    steps :select, :media, :tracking

    # GET /resource_steps/select
    # GET /resource_steps/media
    # GET /resource_steps/tracking
    def show
        @step = step
        case step
        when :media
            @resource ||= Resource.new
            if params[:medium] && Medium.children.include?(params[:medium])
                @resource.medium = Medium.subclass(params[:medium]).new
                setting_main_tags
            else
                redirect_to wizard_path(steps.first), alert: 'Please select a valid media'
                return
            end
        when :tracking
            set_resource
            if @resource.nil? || @resource.status == 'active'
                redirect_to wizard_path(steps.first), alert: 'No media available'
                return
            end
        else
            set_resource unless step.to_s == steps.first.to_s
        end
        render_wizard
    end

    # PATCH/PUT /resource_steps/tracking
    def update
        params[:resource][:status] = step.to_s
        params[:resource][:status] = 'active' if step == steps.last
        @resource.update_attributes(resource_params)
        render_wizard @resource
    end

    # POST /resource_steps/media
    # POST /resource_steps/media.json
    def create
        m = Medium.subclass(params[:resource][:medium_type])
        @medium = m.create(medium_attributes_params)

        if upload_limit_exceeded?(@medium)
            @medium.errors.add(:user, '- Upload Limit (700MB) exceeded!')
            respond_to do |format|
                format.html { redirect_to wizard_path(:select), alert: 'Upload Limit (700MB) exceeded!' }
                format.json { render json: @medium.errors.full_messages, status: :unprocessable_entity }
            end
            return
        end

        medium_params_delete!
        @resource = Resource.new(resource_params)
        @resource.user = current_user
        @resource.status = 'media'
        @resource.medium = @medium unless @medium.nil?

        respond_to do |format|
            if @resource.save
                format.html { redirect_to wizard_path(:tracking) }
                format.json { head :no_content }
            else
                setting_main_tags
                @step = 'media'
                format.html { render 'media' }
                format.json { render json: @resource.errors.full_messages, status: :unprocessable_entity }
            end
        end
    end

    private

    # check if user upload exceeded
    def upload_limit_exceeded?(medium)
        upload_limit = 734_003_200
        newsize = current_user.size_of_uploads + medium.size
        return true if newsize > upload_limit
        false
    end

    # PARAMS Whitelist
    def resource_params
        params.require(:resource).permit(
            :id,
            :title,
            :description,
            :tag_list,
            :distance,
            :altitude_up,
            :altitude_down,
            :medium_type,
            medium_attributes: [:upload, :link, images_attributes: [:id, :pic]],
            tracks_attributes: [:latitude, :longitude, :order, :id],
            level_tags: [],
            season_tags: [],
            door_tags: []
        )
    end

    # set redirect after finishing steps
    def redirect_to_finish_wizard(_options = nil)
        redirect_to medium_path(@resource), notice: 'Media was successfully created'
    end

    # set the resource
    # tracking step
    def set_resource
        @resource = current_user.resources.first
    end

    # get the medium attributes parameters
    def medium_attributes_params
        resource_params[:medium_attributes]
    end

    # remove medium from parameters
    def medium_params_delete!
        params[:resource].delete(:medium_attributes)
        params[:resource].delete(:medium_type)
    end

    # set main tags
    def setting_main_tags
        @season_tags = Tag.season_tags
        @door_tags = Tag.door_tags
        @level_tags = Tag.level_tags
    end
end
