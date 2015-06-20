##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class AddReadToMessages < ActiveRecord::Migration
    def up
        add_column :messages, :read, :boolean, default: false
    end

    def down
        remove_column :messages, :read
    end
end
