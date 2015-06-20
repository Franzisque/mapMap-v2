##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class DropVideos < ActiveRecord::Migration
    def up
        drop_table :videos
    end

    def down
        create_table :videos do |t|
            t.string :movie_type
            t.integer :movie_id
            t.timestamps
        end
    end
end
