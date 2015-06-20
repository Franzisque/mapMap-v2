##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class AddRoleIdToUser < ActiveRecord::Migration
    def change
        remove_column :users, :role
        add_column :users, :role_id, :integer
    end
end
