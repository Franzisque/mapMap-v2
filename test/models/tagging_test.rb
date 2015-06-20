##
# tagging_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class TaggingTest < ActiveSupport::TestCase
    def tagging
        @tagging ||= Tagging.new
    end

    def test_valid
        assert tagging.valid?
    end
end
