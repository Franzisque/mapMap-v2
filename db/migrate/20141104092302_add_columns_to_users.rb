##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class AddColumnsToUsers < ActiveRecord::Migration
    def change
        add_column :users, :username, :string
        add_column :users, :firstname, :string
        add_column :users, :lastname, :string
        add_column :users, :birthday, :string
        add_column :users, :role, :string, null: false, default: 'default'
        add_column :users, :gender, :string, null: false, default: 'female'
        add_index :users, :username, unique: true
    end
end
