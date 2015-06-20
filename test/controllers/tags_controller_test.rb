##
# tags_controller_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class TagsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    def setup
        @tag = Tag.new(name: 'mountain_biking')
    end

    test 'should get all tags as json' do
        get :index, format: 'json'
        assert_response :success
        assert_not_nil assigns(:tags)
    end
end
