##
# message_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
    def setup
        @message_empty = Message.new
    end

    def teardown
        User.destroy_all
        Message.destroy_all
    end

    test 'must not be empty' do
        assert @message_empty.invalid?
        assert @message_empty.errors.any?
    end

    test 'presence of sender, receiver and text' do
        @user = FactoryGirl.create(:user)
        @admin = FactoryGirl.create(:admin)
        @message = Message.new(sender: @user, receiver: @admin, text: 'Holadrio')
        assert @message.valid?
        assert_not @message.errors.any?
    end
end
