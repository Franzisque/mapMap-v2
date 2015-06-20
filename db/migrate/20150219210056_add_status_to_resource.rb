##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class AddStatusToResource < ActiveRecord::Migration
    def up
        add_column :resources, :status, :string
    end

    def down
        remove_column :resources, :status
    end
end
