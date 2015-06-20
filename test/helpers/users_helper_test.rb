##
# user_helper_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class UsersHelperTest < ActionView::TestCase
    test 'should display Mr. if gender male is given' do
        assert_equal 'Mr. Max Mustermann', display_name('male', 'Max Mustermann')
    end

    test 'should display Ms. if gender female is given' do
        assert_equal 'Ms. Susi Musterfrau', display_name('female', 'Susi Musterfrau')
    end

    test 'should display name if no gender is given' do
        [nil, ''].each do |gender_value|
            assert_equal 'Max Mustermann', display_name(gender_value, 'Max Mustermann')
        end
    end

    test 'should return media button link' do
        expected_link = "<a class=\"media-button\" data-remote=\"true\" href=\"/video_test\">Video</a>"
        assert_equal expected_link, user_resource_link('Video', '/video_test')
    end

    test 'should return active media button link' do
        params[:medium] = 'video'
        expected_link = "<a class=\"media-button active\" data-remote=\"true\" href=\"/video_test\">Video</a>"
        assert_equal expected_link, user_resource_link('Video', '/video_test')
    end
end
