##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class CreateVotes < ActiveRecord::Migration
    def change
        create_table :votes do |t|
            t.belongs_to :resource, index: true
            t.belongs_to :user
            t.integer :value

            t.timestamps
        end
    end
end
