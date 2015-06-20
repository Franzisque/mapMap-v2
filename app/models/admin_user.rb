##
# admin_user.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class AdminUser < ActiveRecord::Base
    devise :database_authenticatable,
           :recoverable, :rememberable, :trackable, :validatable
end
