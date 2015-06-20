##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class AddColumnVideoLink < ActiveRecord::Migration
    def up
        add_column :video_links, :provider, :string
        add_column :video_links, :vid, :string
    end

    def down
        remove_column :video_links, :provider
        remove_column :video_links, :vid
    end
end
