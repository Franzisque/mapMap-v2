##
# ability.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class Ability
    include CanCan::Ability

    def initialize(user)
        user ||= User.new # guest user (not logged in)

        if user.username.present?
            can :read, User, Resource
            can :manage, User, id: user.id
            can :manage, Resource, user_id: user.id
            can :manage, Comment, user_id: user.id
        else
            can :read, User, Resource
        end
    end
end
