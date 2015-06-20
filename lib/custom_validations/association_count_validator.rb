##
# association_count_validator.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class AssociationCountValidator < ActiveModel::Validations::LengthValidator
    MESSAGES = {
        wrong_length: :association_count_invalid,
        too_short: :association_count_greater_than_or_equal_to,
        too_long: :association_count_less_than_or_equal_to }.freeze

    def initialize(options)
        MESSAGES.each { |key, message| options[key] ||= message }
        super
    end

    def validate_each(record, attribute, _value)
        existing_records = record.send(attribute).reject(&:marked_for_destruction?)
        super(record, attribute, existing_records)
    end
end
