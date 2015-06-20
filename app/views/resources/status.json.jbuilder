##
# resources - status.json.jbuilder
#
# university:       University of Applied Sciences Salzburg
# degree course:    MultiMediaTechnology (BSc)
# usage:	        Multimediaprojekt 3 (MMP3)
# authors:          Stephan Griessner
#                   Manuel Mitterer
#                   Franziska Oberhauser

json.media do
    json.processing @resource.medium.upload_processing
    json.video_url @resource.medium.upload.url(:mp4, timestamp: false)
end
