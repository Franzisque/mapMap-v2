##
# factories.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

FactoryGirl.define do
    # factories for Tag Model
    factory :season_tag, class: Tag do
        name 'summer'
    end

    factory :door_tag, class: Tag do
        name 'outdoor'
    end

    factory :tag do
        name 'mountain'
    end

    # factory for Country Model
    factory :germany, class: Country do
        name 'Germany'
        code 'DE'
    end

    factory :austria, class: Country do
        name 'Austria'
        code 'AT'
    end

    # factory for User Model
    factory :admin, class: User do
        email 'test@example.com'
        password '12345678'
        username 'testadmin1'
        firstname 'max'
        lastname 'mustermann'
        birth_day 28
        birth_month 10
        birth_year 1990
        confirmed_at '2015-01-01 21:06:11'
    end

    factory :user, class: User do
        email 'user@example.com'
        password '12345678'
        username 'testuser2'
        birth_year 1990
        association :country, factory: :germany
        created_at '2015-01-01 20:34:48'
        confirmed_at '2015-01-01 21:06:11'
    end

    factory :user_without_role, class: User do
        email 'user_without_role@example.com'
        password '12345678'
        username 'testuser3'
        confirmed_at '2015-01-01 21:06:11'
    end

    factory :user_birth, class: User do
        email 'user_birth@example.com'
        password '12345678'
        username 'testuser4'
        birth_day 28
        birth_month 10
        confirmed_at '2015-01-01 21:06:11'
    end

    factory :facebook_authorization, class: Authorization do
        provider 'facebook'
        uid '12345678901234567'
    end

    factory :user_facebook, class: User do
        email 'fb_user@example.com'
        password '12345678'
        username 'facebook_user'
        association :authorization, factory: :facebook_authorization
    end

    factory :gravatar_image, class: Avatar do
        path 'https://secure.gravatar.com/avatar/ad255c824b69b298467979e80ee0706b.png'
        provider 'gravatar'
    end

    factory :facebook_image, class: Avatar do
        path 'http://graph.facebook.com/12345678901234567/picture'
        provider 'facebook'
    end

    # factory for Resource Model
    factory :image, class: Image do
        pic { fixture_file_upload 'test/fixtures/files/charlie_masche.jpg', 'image/jpg' }
    end

    factory :album, class: Album do
        images { build_list :image, 2 }
    end

    factory :video_upload, class: VideoUpload do
        upload { fixture_file_upload 'test/fixtures/files/charlie.mp4', 'video/mp4' }
    end

    factory :video_link_youtube, class: VideoLink do
        link 'https://www.youtube.com/watch?v=SILvPVVAhBo'
    end

    factory :video_link_vimeo, class: VideoLink do
        link 'http://vimeo.com/channels/staffpicks/117669654'
    end

    factory :album_resource, class: Resource do
        title 'Test Album'
        description 'this is a test description'
        medium_type 'Album'
        association :medium, factory: :album
        association :user, factory: :user
        tracks { build_list :track, 2 }
        before(:create) do |album|
            album.tags << FactoryGirl.create(:season_tag)
            album.tags << FactoryGirl.create(:door_tag)
        end
    end

    factory :video_upload_resource, class: Resource do
        title 'Test Video Upload'
        description 'this is a test description'
        medium_type 'VideoUpload'
        association :medium, factory: :video_upload
        association :user, factory: :user_birth
        before(:create) do |upload|
            upload.tags << FactoryGirl.create(:season_tag)
            upload.tags << FactoryGirl.create(:door_tag)
        end
    end

    factory :video_link_resource, class: Resource do
        title 'Test Video Link'
        description 'this is a test description'
        medium_type 'VideoLink'
        association :medium, factory: :video_link_youtube
        association :user, factory: :admin
        before(:create) do |link|
            link.tags << FactoryGirl.create(:season_tag)
            link.tags << FactoryGirl.create(:door_tag)
        end
    end

    # factory for track
    factory :track, class: Track do
        latitude 65.6778
        longitude 85.768
        order 0
    end
end
