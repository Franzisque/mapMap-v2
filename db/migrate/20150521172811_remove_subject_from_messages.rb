##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class RemoveSubjectFromMessages < ActiveRecord::Migration
    def up
        remove_column :messages, :subject
    end

    def down
        add_column :messages, :subject, :string
    end
end
