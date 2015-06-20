##
# messages_controller.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class MessagesController < InheritedResources::Base
    before_filter :authenticate_user!

    # GET /messages/
    # GET /messages/:username
    def index
        @message_count = (current_user.messages_in + current_user.messages_out).count
        @contacts = current_user.contacts

        if params[:username]
            @contact = User.find_by_username(params[:username])
            @message_count += 1
            @contacts << @contact unless @contacts.include?(@contact)
        else
            @contact = @contacts.first
        end

        if @contact && @contact == current_user
            redirect_to messages_url, alert: 'Cannot send messages to yourself'
        elsif @contact
            @message ||= Message.new
            @receiver = @contact
        elsif @message_count != 0
            redirect_to messages_url, alert: 'User not found'
        end

        current_user.messages_in.where(sender: @contact).each do |message|
            message.read = true
            message.save!
        end

        @messages = current_user.messages_in.where(sender: @contact) + current_user.messages_out.where(receiver: @contact)
        @messages = @messages.sort_by(&:updated_at)
    end

    # GET /messages/new
    def new
        @message ||= Message.new
        @receiver = User.find(params[:receiver_id])
      rescue ActiveRecord::RecordNotFound
          redirect_to root_url, alert: 'User not found'
    end

    # POST /messages/
    def create
        @message = Message.new(message_params)
        @message.sender = current_user
        @receiver = User.find(params[:message][:receiver_id])
        if !@receiver.allowcontact
            @message.errors[:base] << "User doesn't want to receive Messages"
            respond_to do |format|
                format.html { redirect_to usermessage_path(@receiver.username), alert: "User doesn't want to receive Messages" }
                format.js
            end
        elsif !current_user.allowcontact
            @message.errors[:base] << "You can't send messages, if you dont want to receive messages."
            respond_to do |format|
                format.html { redirect_to usermessage_path(@receiver.username), alert: "You can't send messages, if you dont want to receive messages." }
                format.js
            end
        else
            @message.save

            respond_to do |format|
                if @message.save
                    format.html { redirect_to usermessage_path(@receiver.username), notice: 'Message was successfully sent.' }
                    format.js
                else
                    format.html { render action: 'new', alert: 'Message was not sent.' }
                    format.js
                end
            end
        end
    end

    # DELETE /messages/:id
    def destroy
        @message = Message.find(params[:id])
        if @message.sender == current_user
            redirect = @message.receiver.username
        else
            redirect = @message.sender.username
        end

        @message.destroy
        respond_to do |format|
            format.html { redirect_to usermessage_path(redirect), notice: 'Message deleted.' }
            format.js
        end
    end

    private

    # PARAMS Whitelist
    def message_params
        params.require(:message).permit(
            :text,
            :receiver_id
        )
    end
end
