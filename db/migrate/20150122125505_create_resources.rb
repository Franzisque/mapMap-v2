##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class CreateResources < ActiveRecord::Migration
    def change
        create_table :resources do |t|
            t.string :title, null: false, default: ''
            t.text :description
            t.references :user, null: false
            t.integer :views, default: 0
            t.string :medium_type
            t.integer :medium_id
            t.timestamps
        end
    end
end
