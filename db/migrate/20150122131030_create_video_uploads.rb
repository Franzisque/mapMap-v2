##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class CreateVideoUploads < ActiveRecord::Migration
    def change
        create_table :video_uploads do |_t|
        end
        add_attachment :video_uploads, :upload
    end
end
