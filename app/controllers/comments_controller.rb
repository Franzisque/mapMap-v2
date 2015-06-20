##
# comments_controller.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class CommentsController < InheritedResources::Base
    before_filter :authenticate_user!
    load_and_authorize_resource
    before_action :set_comment, only: [:edit, :update, :destroy]

    # GET /resources/1/comments/1/edit
    # GET /resources/1/comments/1/edit.js
    def edit
    end

    # PATCH/PUT /resources/1/comments/1
    # PATCH/PUT /resources/1/comments/1.js
    def update
        respond_to do |format|
            if @comment.update(comment_params)
                format.html { redirect_to medium_path(@resource), notice: 'Comment was successfully updated.' }
                format.js
            else
                format.html { render action: 'edit' }
                format.js { render action: 'edit' }
            end
        end
    end

    # POST /resources/1/comments
    # POST /resources/1/comments.js
    def create
        @resource = Resource.find(params[:medium_id])
        @comment = Comment.new(comment_params)
        @comment.resource = @resource
        @comment.user = current_user
        respond_to do |format|
            if @comment.save
                format.html { redirect_to medium_path(@resource), notice: 'Comment was successfully created.' }
                format.js
            else
                format.html { redirect_to medium_path(@resource), alert: 'Comment was not created.' }
                format.js
            end
        end
    end

    # DELETE /resources/1/comments/1
    # DELETE /resources/1/comments/1.js
    def destroy
        @comment.destroy
        respond_to do |format|
            format.html { redirect_to medium_path(@resource) }
            format.js
        end
    end

    private

    # set resource for edit, update and destroy action
    def set_comment
        @resource = Resource.find(params[:medium_id])
        @comment = Comment.find(params[:id])
        @comments = Comment.where(resource: @resource)
    end

    # PARAMS Whitelist
    def comment_params
        params.require(:comment).permit(:text)
    end
end
