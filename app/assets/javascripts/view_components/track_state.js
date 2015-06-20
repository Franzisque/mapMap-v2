/**
 * track_state.js
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

    var ViewHelper = function() {
        this.displayDrawState();
    };

    ViewHelper.prototype.displayDrawState = function() {
        var that = this;
        $('.help-icon').click(function() {
            var feedbackContainer = $(this).next('.help-text');
            feedbackContainer.toggleClass('help-active');
            that.toggleFeedbackVisibility(feedbackContainer);
        });
        this.deleteState = false;
    };

    /**
     * display the right text in the "helper-box" above the track-buttons
     * @param buttonText
     */
    ViewHelper.prototype.displayUserFeedback = function(buttonText) {
        var feedbackContainer = $('.draw-delete-buttons').prev().find('.help-text');
        if (buttonText === "Draw Track") {
            this.deleteState = false;
            feedbackContainer
                .text('You are currently drawing: click on the map where you want ' +
                    'to add track-points')
        } else if (buttonText === "Delete Track-Point") {
            this.deleteState = true;
            feedbackContainer
                .text('click on the cross-icons to delete a single circle - if you want to delete ' +
                    'the whole track, delete the first circle')
        } else if (buttonText === "Expand Track") {
            feedbackContainer
                .text('Click in the map to draw further track-points')
        } else if(!this.deleteState) {
            feedbackContainer
                .text('Drag the track-circles to change their position')
        }
        feedbackContainer.addClass('help-active');
        this.toggleFeedbackVisibility(feedbackContainer);
    };

    /**
     * toggle the visible state of the "helper-box"
     * @param $element
     */
    ViewHelper.prototype.toggleFeedbackVisibility = function($element) {
        if ($element.hasClass('help-active')) {
            $element.show(500);
        } else {
            $element.hide(500);
        }
    };


    namespace.ViewHelper = ViewHelper;

}(window, app));