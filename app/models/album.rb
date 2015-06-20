##
# album.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class Album < ActiveRecord::Base
    IMAGES_COUNT_MIN = 1

    validates :images, association_count: { minimum: IMAGES_COUNT_MIN }
    has_one :resource, as: :medium, dependent: :destroy
    has_many :images, dependent: :destroy
    accepts_nested_attributes_for :images, allow_destroy: true, reject_if: :all_blank

    def thumburl
        images.first.pic.url(:medium, timestamp: false)
    end

    def size
        filesize = 0
        images.each do |image|
            filesize += image.pic_file_size
        end
        filesize
    end
end
