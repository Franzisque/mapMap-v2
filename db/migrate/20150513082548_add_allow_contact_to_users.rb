##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class AddAllowContactToUsers < ActiveRecord::Migration
    def up
        add_column :users, :allowcontact, :boolean, default: true
    end

    def down
        remove_column :users, :allowcontact
    end
end
