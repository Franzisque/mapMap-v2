##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class CreateTaggings < ActiveRecord::Migration
    def change
        create_table :taggings do |t|
            t.belongs_to :tag, index: true
            t.belongs_to :resource, index: true

            t.timestamps
        end
    end
end
