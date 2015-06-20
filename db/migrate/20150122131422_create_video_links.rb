##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class CreateVideoLinks < ActiveRecord::Migration
    def change
        create_table :video_links do |t|
            t.string :link
        end
    end
end
