##
# image.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class Image < ActiveRecord::Base
    belongs_to :album

    has_attached_file :pic,
                      styles: {
                          large: '800x800>',
                          medium: '500x500>',
                          small: '300x300>',
                          thumb: '100x100>'
                      }

    validates :pic, presence: true
    validates :pic, image_dimension: { min_width: 800, min_height: 600 }
    validates_attachment_content_type :pic, content_type: /\Aimage\/.*\Z/
    validates_attachment_file_name :pic, matches: [/png\Z/, /jpe?g\Z/, /JPG\Z/, /gif\Z/], message: 'must be an image file: gif, jpg, jpeg, JPG, png'

    before_post_process :check_for_geo_data

    def check_for_geo_data
        if %w(jpg jpeg JPG).include?(pic_file_name)
            exif = EXIFR::JPEG.new(pic.queued_for_write[:original].path)
            return if exif.nil? || !exif.exif? || exif.gps.nil?
            self.latitude = exif.gps.latitude
            self.longitude = exif.gps.longitude
        end
    end
end
