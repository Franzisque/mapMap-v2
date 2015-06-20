##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class CreateRoles < ActiveRecord::Migration
    def change
        create_table :roles do |t|
            t.string :name

            t.timestamps
        end
    end
end
