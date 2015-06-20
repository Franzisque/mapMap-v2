##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class ChangeBirthdayToUsers < ActiveRecord::Migration
    def change
        remove_column :users, :birthday, :text
        add_column :users, :birth_day, :integer
        add_column :users, :birth_month, :integer
        add_column :users, :birth_year, :integer
    end
end
