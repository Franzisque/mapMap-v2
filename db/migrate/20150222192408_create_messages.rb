##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class CreateMessages < ActiveRecord::Migration
    def change
        create_table :messages do |t|
            t.string :subject
            t.text :text
            t.integer :sender_id
            t.integer :receiver_id

            t.timestamps
        end
    end
end
