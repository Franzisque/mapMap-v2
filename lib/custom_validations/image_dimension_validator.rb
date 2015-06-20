##
# image_dimension_validator.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class ImageDimensionValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        width = options[:min_width]
        height = options[:min_height]

        if value.present?
            image_dimension = Paperclip::Geometry.from_file(value.queued_for_write[:original].path)
            record.errors[attribute] << "width must be greater than #{width}px" unless image_dimension.width >= width
            record.errors[attribute] << "height must be greater than #{height}px" unless image_dimension.height >= height
        else
            record.errors[attribute] << 'is not a valid image'
        end
    end
end
