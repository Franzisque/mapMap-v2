##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class RemoveColumnsFromUsers < ActiveRecord::Migration
    def up
        remove_column :users, :provider
        remove_column :users, :uid
    end

    def down
        add_column :users, :provider, :string
        add_column :users, :uid, :string
    end
end
