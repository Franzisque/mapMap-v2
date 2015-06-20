##
# avatar.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class Avatar < ActiveRecord::Base
    belongs_to :user

    validates :user, :provider, presence: true
    validates :provider, inclusion: { in: %w(facebook gravatar) }

    before_create :set_image_path

    # get url of avatar
    def url(size = 'large')
        send("#{provider}", size)
    end

    private

    # set avatar on provider
    def set_image_path
        case provider
        when 'facebook' then self.path = set_facebook_url
        when 'gravatar' then self.path = set_gravatar_url
        else
            self.path = set_gravatar_url
            self.provider = 'gravatar'
        end

        self.is_active = true if Avatar.where(user: user).count == 0
    end

    # set url for facebook image
    def set_facebook_url
        facebook_id = user.authorization.uid
        "http://graph.facebook.com/#{facebook_id}/picture"
    end

    # set url for gravatar image
    def set_gravatar_url
        gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
        "https://secure.gravatar.com/avatar/#{gravatar_id}.png"
    end

    # size of facebook avatar image
    # returns finale url of image
    def facebook(size)
        url = path + '?type='
        case size
        when 'large' then url += 'large'
        when 'normal' then url += 'normal'
        when 'small' then url += 'small'
        else
            url += 'square'
        end
    end

    # size of gravatr avatar image
    # returns finale url of image
    def gravatar(size)
        url = path + '?s='
        case size
          when 'large' then pic_size = 200
          when 'normal' then pic_size = 100
          when 'small' then pic_size = 50
          else
              pic_size = 100
        end
        url += pic_size.to_s
    end
end
