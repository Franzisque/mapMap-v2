##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class CreateTracks < ActiveRecord::Migration
    def change
        create_table :tracks do |t|
            t.float :latitude
            t.float :longitude
            t.integer :order
            t.references :resource
        end
    end
end
