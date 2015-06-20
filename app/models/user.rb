##
# user.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class User < ActiveRecord::Base
    belongs_to :country
    has_many :resources, -> { order(created_at: :desc) }, dependent: :destroy
    has_one :authorization, dependent: :destroy
    has_many :messages_in, class_name: 'Message', foreign_key: 'receiver_id', dependent: :destroy
    has_many :messages_out, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
    has_many :avatars, dependent: :destroy
    has_many :comments, dependent: :destroy

    after_create :set_default_avatar

    after_initialize do
        @default_instance_variables = instance_variables
    end

    devise :database_authenticatable, :registerable, #:confirmable,
           :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

    # CONSTANTS
    GENDER = %w(male female)
    MONTHS = [['January', 1], ['February', 2], ['March', 3], ['April', 4], ['Mai', 5], ['June', 6], ['July', 7], ['August', 8], ['September', 9], ['October', 10], ['November', 11], ['December', 12]]
    DAYS = (1..31).to_a
    START_YEAR = Time.now.year - 100
    END_YEAR = Time.now.year - 10
    YEAR_RANGE = (START_YEAR..END_YEAR).to_a.reverse!

    # Validations
    validates :username, presence: true, uniqueness: true, format: { with: /\A[A-Za-z0-9_]+\z/, message: "only allows letters, numbers and '_'" }
    validates :gender, inclusion: { in: GENDER, message: '%{value} is not a valid gender' }, allow_blank: true
    validates :birth_day, inclusion: { in: DAYS }, allow_nil: true
    validates :birth_month, inclusion: { in: (1..12) }, allow_nil: true
    validates :birth_year, inclusion: { in: YEAR_RANGE }, allow_nil: true
    validates :firstname, format: { with: /\A([a-zA-ZÄÜÖäüöß]+(\s|\-)?)+\w\z/, message: 'only allows letters' }, allow_blank: true
    validates :lastname, format: { with: /\A([a-zA-ZÄÜÖäüöß]+(\s|\-)?)+\w\z/, message: 'only allows letters' }, allow_blank: true

    # create user with facebook login unless user (email) exists
    # returns user
    def self.from_omniauth(auth, current_user)
        # find or create authorization
        authorization = Authorization.where(
            provider: auth.provider,
            uid: auth.uid
        ).first_or_initialize

        if authorization.user.blank?
            user = current_user.nil? ? User.where('email = ?', auth['info']['email']).first : current_user

            if user.blank?
                user = User.create!(
                    email: auth.info.email,
                    password: Devise.friendly_token[0, 20],
                    username: auth.info.name.gsub(/[^A-Za-z0-9_]/, '_')
                )
            end

            authorization.user = user
            authorization.save!

            user.avatars.find_or_create_by(provider: auth.provider)
        end
        authorization.user
    end

    # add functionality to new_with_session method of devise (facebook login)
    # sets users email unless email is given already
    def self.new_with_session(params, session)
        super.tap do |user|
            if data = session['devise.facebook_data'] && session['device.facebook_data']['extra']['raw_info']
                user.email = data['email'] if user.email.blank?
            end
        end
    end

    # check if user registered via facebook
    def provider_set?
        authorization.present?
    end

    # get name
    def name
        @name ||= firstname + ' ' + lastname unless firstname.blank? || lastname.blank?
    end

    # get profile image url with given size
    def image_url(size = 'large')
        selected_avatar.url(size)
    end

    # get birthday
    def birthday
        @birthday ||= set_birthday
    end

    # get avatar instance
    def selected_avatar
        @avatar ||= avatars.where(is_active: true).first
    end

    # get avatar id
    def avatar
        selected_avatar.id unless selected_avatar.nil?
    end

    # set avatar
    def avatar=(id)
        @old_avatar = selected_avatar
        @new_avatar = avatars.find(id)
        if @new_avatar.present? && @new_avatar != @old_avatar
            @old_avatar.is_active = false
            @new_avatar.is_active = true
            @old_avatar.save
            @new_avatar.save
        end
    end

    # remove instance variables on reload
    def reload(options = nil)
        super
        instance_variables.each do |ivar|
            if ivar == :'@default_instance_variables' || @default_instance_variables.include?(ivar)
                next
            end
            remove_instance_variable(ivar)
        end
    end

    # get total memory size of uploads
    def size_of_uploads
        uploaded_size = 0
        resources.each do |resource|
            uploaded_size += resource.medium.size
        end
        uploaded_size
    end

    # get user contacts (messages)
    def contacts
        messages = messages_in + messages_out
        messages.sort_by(&:created_at)

        contacts = []

        messages.each do |message|
            if !contacts.include?(message.sender) && message.sender != self
                contacts << message.sender
            end
            if !contacts.include?(message.receiver) && message.receiver != self
                contacts << message.receiver
            end
        end

        contacts
    end

    # check if unread messages available
    def has_unread_messages(from)
        messages_in.each do |message|
            return true if message.sender == from && message.read == false
        end
        false
    end

    private

    # returns the birthday if information given
    # => Day. Month Year
    # => Day. Month
    # => Year
    # => nil
    def set_birthday
        day = birth_day
        month = birth_month
        year = birth_year
        month = MONTHS[month - 1][0] unless month.blank?

        if day.present? && month.present?
            birthday = day.to_s + '. ' + month.to_s
            birthday += ' ' + year.to_s unless year.blank?
        elsif year.present?
            birthday = year.to_s
        else
            birthday = nil
        end

        birthday
    end

    # creates a default avatar after register
    def set_default_avatar
        avatars.create!(provider: 'gravatar')
    end
end
