##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class AddUploadProcessingToVideoUpload < ActiveRecord::Migration
    def up
        add_column :video_uploads, :upload_processing, :boolean
    end

    def down
        remove_column :video_uploads, :upload_processing
    end
end
