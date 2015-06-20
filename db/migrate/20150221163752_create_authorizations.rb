##
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class CreateAuthorizations < ActiveRecord::Migration
    def change
        create_table :authorizations do |t|
            t.string :provider
            t.string :uid
            t.string :token
            t.string :secret
            t.references :user
            t.timestamps
        end
    end
end
