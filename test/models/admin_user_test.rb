##
# admin_user_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class AdminUserTest < ActiveSupport::TestCase
    def admin_user
        @admin_user ||= AdminUser.new
    end
end
