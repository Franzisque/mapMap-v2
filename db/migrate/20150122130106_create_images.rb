##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class CreateImages < ActiveRecord::Migration
    def change
        create_table :images do |t|
            t.string :pic_file_name
            t.float :pic_file_size
            t.string :pic_content_type
            t.date :pic_updated_at
            t.float :latitude
            t.float :longitude
            t.references :album
            t.timestamps
        end
    end
end
