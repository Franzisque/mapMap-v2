##
# omniauth_callbacks_controller.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # facebook login
    def facebook
        @user = User.from_omniauth(request.env['omniauth.auth'], current_user)
        # @user.skip_confirmation! # skip confirmation for facebook login
        if @user.persisted?
            sign_in_and_redirect @user, event: :authentication
            set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
        else
            session['devise.facebook_data'] = request.env['omniauth.auth']
            redirect_to new_user_registration_url
        end
    end

    # GET|POST /users/auth/facebook/callback
    def failure
        super
    end
end
