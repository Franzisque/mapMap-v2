##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class CreateTags < ActiveRecord::Migration
    def change
        create_table :tags do |t|
            t.string :name

            t.timestamps
        end
    end
end
