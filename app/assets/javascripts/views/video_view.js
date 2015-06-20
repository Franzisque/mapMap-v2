/**
 * video_view.js
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
     * get user input concerning the video-logic
     * and the video-upload-view
     * deliver it to video-controller
     * @constructor
     */
    var VideoView = function() {

        this.linkNode = $('#form_video_link').clone();
        this.uploadNode = $('#form_video_upload').clone();
        this.uploadRadioButton = $('#video_resource_type_videoupload');
        this.linkRadioButton = $('#video_resource_type_videolink');
        this.container = $('#resource_container');

        this.buttonCheck();
        this.onVideoUpload();
        this.onSelectSrc();
    };

    VideoView.prototype.buttonCheck = function() {
        var that = this;
        if (this.uploadRadioButton.is(':checked')) {
            that.localVideoUpload();
        } else {
            that.srcIntegration();
        }
    };

    VideoView.prototype.onSelectSrc = function() {
        this.linkRadioButton.click(function() {
            this.srcIntegration();
        }.bind(this));
    };

    VideoView.prototype.onVideoUpload = function() {
        this.uploadRadioButton.click(function() {
            this.localVideoUpload();
        }.bind(this));
    };

    VideoView.prototype.localVideoUpload = function() {
        this.changeForm(this.uploadRadioButton, this.uploadNode, this.container);
    };

    VideoView.prototype.srcIntegration = function() {
        this.changeForm(this.linkRadioButton, this.linkNode, this.container);
    };

    VideoView.prototype.changeForm = function(radioButton, node, container) {

        if (radioButton.is(':checked')) {
            container.empty();
            node.appendTo(container);
        }
    };

    namespace.VideoView = VideoView;

})(window, app);