##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class RemoveImageFromUsers < ActiveRecord::Migration
    def up
        remove_column :users, :image
    end

    def down
        add_column :users, :image, :string
    end
end
