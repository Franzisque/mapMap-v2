##
# vote.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class Vote < ActiveRecord::Base
    belongs_to :resource
    belongs_to :user

    validates :resource, uniqueness: { scope: :user }
    validates :value, inclusion: { in: [1, 0, -1] }
end
