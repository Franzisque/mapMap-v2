##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class AddAltitudeToResources < ActiveRecord::Migration
    def up
        add_column :resources, :altitude_up, :decimal, default: 0
        add_column :resources, :altitude_down, :decimal, default: 0
    end

    def down
        remove_column :resources, :altitude_up
        remove_column :resources, :altitude_down
    end
end
