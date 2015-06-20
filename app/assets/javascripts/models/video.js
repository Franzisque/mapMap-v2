/**
 * video.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

var app = window.app || {};

(function(window, namespace) {

    "use strict";

    /**
     * video object with change-event on video added and
     * an ajax function to get data from the backend
     * @constructor
     */
    var Video = function() {
        this.videoAdded = new ChangeEvent(this);
        this.getVideoData();
    };

    /**
     * ajax request to video-controller to get the
     * latitude and longitude of actual videos
     */
    Video.prototype.getVideoData = function() {
        var that = this;
        $.ajax({
            type: "GET",
            dataType: "json",
            url: "/videos",
            success: function(data) {
                var videoSrc = that.checkVideoSource(data);

                // notify MarkerController about video-data
                that.videoAdded.notify({
                    videoAttr: data,
                    src: videoSrc
                });
            }
        });
    };

    /**
     * verify what kind of video is received
     */
    Video.prototype.checkVideoSource = function(data) {
        var tmp = [];
        for (var i = 0; i < data.length; i++) {
            if (data[i].resource_type == "VideoLink") {
                tmp.push(this.videoLink(data[i].resource));
            } else {
                tmp.push(this.videoUpload(data[i].resource));
            }
        }
        return tmp;
    };

    /**
     * load youtube iframe if the video source is a link
     */
    Video.prototype.videoLink = function(resource) {
        return '<iframe class="youtube-player"' +
            'type="text/html" width="320"' +
            'height="240" src="' + resource + '"' +
            'allowfullscreen frameborder="0">' +
            '</iframe>'
    };

    /**
     * load video tag if the video source is a link
     */
    Video.prototype.videoUpload = function(resource) {
        return '<video width="320" height="240" controls>' +
            '<source src="' + resource[1] + '">' +
            '<source src="' + resource[0] + '">' +
            'Your browser does not support the video tag.' +
            '</video>'
    };

    namespace.Video = Video;

})(window, app);