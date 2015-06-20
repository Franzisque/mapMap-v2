##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class AddThumbPathToVideoLink < ActiveRecord::Migration
    def up
        add_column :video_links, :thumb_path, :string
    end

    def down
        remove_column :video_links, :thumb_path
    end
end
