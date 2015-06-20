##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class RemoveColumnsFromAuthorizations < ActiveRecord::Migration
    def up
        remove_column :authorizations, :token
        remove_column :authorizations, :secret
    end

    def down
        add_column :authorizations, :token, :string
        add_column :authorizations, :secret, :string
    end
end
