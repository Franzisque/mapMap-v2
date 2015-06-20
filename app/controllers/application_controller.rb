##
# application_controller.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    before_filter :configure_permitted_parameters, if: :devise_controller?

    # store last path in session - except users path and ajax requests
    def store_last_location
        return unless request.get?
        if !request.fullpath.match('/users') && !request.xhr?
            session[:previous_location] = request.fullpath
        end
    end

    # set path after log in
    def after_sign_in_path_for(_resource)
        session[:previous_location] || root_path
    end

    # set path after log out
    def after_sign_out_path_for(_resource)
        root_path
    end

    # permission denied, redirect to root path
    rescue_from CanCan::AccessDenied do |exception|
        redirect_to root_url, alert: exception.message
    end

    protected

    # permittet paramters for devise update and sign_up
    def configure_permitted_parameters
        devise_parameter_sanitizer.for(:sign_up) do |u|
            u.permit(:firstname, :lastname, :username, :email, :password, :password_confirmation)
        end

        devise_parameter_sanitizer.for(:account_update) do |u|
            u.permit(
                :firstname,
                :lastname,
                :username,
                :email,
                :password,
                :password_confirmation,
                :gender,
                :birth_day,
                :birth_month,
                :birth_year,
                :country_id,
                :avatar,
                :private,
                :allowcontact
            )
        end
    end
end
