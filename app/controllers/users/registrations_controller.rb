##
# registrations_controller.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class Users::RegistrationsController < Devise::RegistrationsController
    # GET /resource/edit
    def edit
        @countries = Country.all
        super
    end

    # PUT /users/
    def update
        @user = User.find(current_user.id)
        successfully_updated = if needs_password?(@user, params)
                                   @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
                               else
                                   params[:user].delete(:current_password)
                                   @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
                               end

        if successfully_updated
            set_flash_message :notice, :updated
            sign_in @user, bypass: true
            redirect_to after_update_path_for(@user)
        else
            @countries = Country.all
            render action: :edit, alert: 'Could not update user!'
        end
    end

    protected

    # check if user need a password to update changes
    # => user needs a password if updating email or password
    # => returns true or false
    def needs_password?(user, params)
        user.email != params[:user][:email] ||
            params[:user][:password].present? ||
            params[:user][:password_confirmation].present?
    end

    # set path after sign up to user edit
    def after_sign_up_path_for(_resource)
        edit_user_registration_path
    end

    # set path after edit to user edit
    def after_update_path_for(user)
        profile_path(user.username)
    end
end
