##
# video_upload.rb
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

class VideoUpload < ActiveRecord::Base
    has_one :resource, as: :medium, dependent: :destroy

    # paperclip
    has_attached_file :upload, styles: {
        mp4: { geometry: '1280x720', format: 'mp4', streaming: true },
        thumb: { geometry: '320x180', format: 'jpg', time: 2 }
    }, processors: [:transcoder] #:qtfaststart

    validates :upload, presence: true
    validates_attachment_content_type :upload, content_type: /\Avideo\/.*\Z/, message: 'must be a video file'

    # encode the video in background
    process_in_background :upload, url_with_processing: false

    # get thumb image url
    def thumburl
        upload.url(:thumb, timestamp: false)
    end

    # get the size of video
    def size
        upload_file_size
    end
end
