##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class AddPrivateToUsers < ActiveRecord::Migration
    def up
        add_column :users, :private, :boolean, default: false
    end

    def down
        remove_column :users, :private
    end
end
