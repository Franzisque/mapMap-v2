##
# message.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class Message < ActiveRecord::Base
    belongs_to :sender, class_name: 'User'
    belongs_to :receiver, class_name: 'User'

    validates :sender, presence: true
    validates :receiver, presence: true
    validates :text, presence: true
end
