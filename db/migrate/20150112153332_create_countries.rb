##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class CreateCountries < ActiveRecord::Migration
    def change
        create_table :countries do |t|
            t.string :name
            t.string :code

            t.timestamps
        end
    end
end
