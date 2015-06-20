##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class ChangeRolesTable < ActiveRecord::Migration
    def up
        change_column :roles, :name, :string, null: false, default: ''
        add_index :roles, :name, unique: true
    end

    def down
        change_column :roles, :name, :string, null: true, default: nil
        remove_index :roles, :name
    end
end
