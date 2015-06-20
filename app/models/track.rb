##
# track.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class Track < ActiveRecord::Base
    belongs_to :resource
    validates :latitude, :longitude, presence: true
    validates :latitude, numericality: { greater_than: -85, less_than: 85 }
    validates :longitude, numericality: { greater_than: -180, less_than: 180 }
end
