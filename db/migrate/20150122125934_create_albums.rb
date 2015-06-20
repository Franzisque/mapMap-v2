##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class CreateAlbums < ActiveRecord::Migration
    def change
        create_table :albums do |t|
            t.integer :thumb_id
        end
    end
end
