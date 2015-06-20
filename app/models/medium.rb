##
# medium.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class Medium
    @@children = %w(Album VideoLink VideoUpload)

    def self.subclass(s)
        return s.constantize if @@children.include?(s)
        fail "#{s} is not a valid Media"
    end

    def self.all_subclasses
        @@children.map(&:constantize)
    end

    def self.children
        @@children
    end
end
