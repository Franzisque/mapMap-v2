##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class CreateAvatars < ActiveRecord::Migration
    def change
        create_table :avatars do |t|
            t.belongs_to :user, index: true
            t.string :path
            t.string :provider
            t.boolean :is_active, null: false, default: false
            t.timestamps
        end
    end
end
