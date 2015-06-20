##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class DropRole < ActiveRecord::Migration
    def up
        drop_table :roles
        remove_column :users, :role_id
    end

    def down
        create_table :roles do |t|
            t.string :name
        end
        add_column :users, :role_id, :integer
    end
end
