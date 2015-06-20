##
# user_flow_test.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
    include Capybara::DSL

    def setup
        @user = FactoryGirl.create(:user)
        @youtube_resource = FactoryGirl.create(:video_link_resource)
        Tag.main_tags.each do |name|
            Tag.where(name: name).first_or_create
        end
    end

    def teardown
        User.destroy_all
        Tag.destroy_all
        Resource.destroy_all
    end

    def log_in_user
        visit(new_user_session_path)
        fill_in('Email', with: @user.email)
        fill_in('Password', with: attributes_for(:user)[:password])
        click_button('Log in')
    end

    test 'Login user' do
        log_in_user
        assert_equal root_path, current_path
    end

    test 'register new user' do
        visit(root_path)
        click_link('Sign up')
        assert_equal new_user_registration_path, current_path

        fill_in('Email', with: 'integration@user.com')
        fill_in('Username', with: 'integration_user')
        fill_in('Password', with: '12345678')
        fill_in('Password confirmation', with: '12345678')
        click_button('Sign up')

        assert_equal edit_user_registration_path, current_path
    end

    test 'visit user profile' do
        log_in_user
        click_link('Profile')
        assert_equal profile_path(@user.username), current_path
        has_content?(@user.username)
    end

    test 'visit about page - logout user' do
        log_in_user
        click_link('About')
        assert_equal about_path, current_path

        click_link('Logout')
        assert_equal root_path, current_path
    end

    test 'edit account settings' do
        log_in_user
        click_link('Edit Account')
        assert_equal edit_user_registration_path, current_path

        fill_in('Username', with: 'Tester12345')
        select('male', from: 'Gender')
        click_button('Update')
        assert_equal profile_path('Tester12345'), current_path
    end

    test 'upload link - user not logged in' do
        visit(root_path)
        click_link('Upload')
        assert_equal new_user_session_path, current_path
    end

    test 'upload - resource youtube link' do
        log_in_user
        click_link('Upload')
        assert_equal resource_step_path(:select), current_path

        click_link('Youtube/Vimeo')
        assert_equal resource_step_path(:media), current_path
        fill_in('Title', with: 'Test title')
        fill_in('Description', with: 'Description test')
        fill_in('Youtube/Vimeo URL', with: 'https://www.youtube.com/watch?v=cs6SBQJJQwM')
        check('summer')
        click_button('Continue')

        assert_equal resource_step_path(:tracking), current_path
    end

    test 'upload - resource album' do
        log_in_user
        click_link('Upload')
        assert_equal resource_step_path(:select), current_path

        click_link('Images')
        assert_equal resource_step_path(:media), current_path
        fill_in('Title', with: 'Test title')
        fill_in('Description', with: 'Description test')
        attach_file('Image upload', 'test/fixtures/files/charlie_masche.jpg')
        check('outdoor')
        click_button('Continue')

        assert_equal resource_step_path(:tracking), current_path
    end

    test 'add comment to resource' do
        log_in_user
        visit(medium_path(@youtube_resource.id))
        assert_equal medium_path(@youtube_resource.id), current_path

        find('#comment_text').set('Test comment')
        click_button('Comment')

        assert_equal medium_path(@youtube_resource.id), current_path
        has_content?('Test comment')
    end

    test 'like resource' do
        log_in_user
        visit(medium_path(@youtube_resource.id))
        assert_equal medium_path(@youtube_resource.id), current_path

        find('.up-vote').click

        assert_equal medium_path(@youtube_resource.id), current_path
        find('.vote-container').has_content?('1')
    end
end
