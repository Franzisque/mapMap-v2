##
# comment.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class Comment < ActiveRecord::Base
    belongs_to :user
    belongs_to :resource

    validates :user, :resource, :text, presence: true
end
