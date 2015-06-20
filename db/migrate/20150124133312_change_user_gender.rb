##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class ChangeUserGender < ActiveRecord::Migration
    def up
        change_column :users, :gender, :string, null: true, default: nil
        change_column :users, :username, :string, null: false, default: ''
    end

    def down
        change_column :users, :gender, :string, null: false, default: ''
        change_column :users, :username, :string, null: true, default: nil
    end
end
