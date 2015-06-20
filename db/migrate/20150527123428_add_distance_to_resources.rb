##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class AddDistanceToResources < ActiveRecord::Migration
    def up
        add_column :resources, :distance, :decimal, default: 0
    end

    def down
        remove_column :resources, :distance
    end
end
