/**
 * gpx_view.js
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
     *
     * @param gpxModel
     * @param $inputFieldId
     * @param $gpxForm
     * @constructor
     */
    var GpxView = function(gpxModel, $gpxForm, $inputFieldId) {

        this.$gpxForm = $gpxForm;

        this.inputFile = document.getElementById($inputFieldId);
        this.inputFileChanged = false;

        this.gpxDataLoad = new ChangeEvent(this);
        this.gpxDataChosen = new ChangeEvent(this);
        this.checkInputField();
        this.loadGpxData();
    };

    /**
     * load gpx file on submit
     */
    GpxView.prototype.loadGpxData = function() {
        this.$gpxForm.unbind('submit');
        this.$gpxForm.submit(function(event) {

            this.$gpxForm.find('.error').remove();

            if (this.inputFileChanged) {
                this.cleanUp();
                this.gpxDataLoad.notify({
                    args: this.inputFile
                });
                this.inputFileChanged = false;
            }

            event.preventDefault();
        }.bind(this));
    };

    /**
     * check if file input changed
     */
    GpxView.prototype.checkInputField = function() {
        $(this.inputFile).off('change').on('change', function(event) {
            if ($('#gpx_upload_button').attr('disabled')) {
                $('#gpx_upload_button').attr('disabled', false);
            }
            if (this.inputFile.files.length < 1) {
                this.cleanUp();
                $('#gpx_upload_button').attr('disabled', true);
            }

            this.inputFileChanged = true;

            event.preventDefault();
        }.bind(this));
    };

    /**
     * create the html to choose a track
     */
    GpxView.prototype.showTrackChooser = function(tracks) {
        var tracklist = "";
        this.cleanUp();

        for (var i = 0; i < tracks.length; i++) {
            if (tracks[i]) {
                tracklist += '<div class="trackname" data-id="' + i + '" data-name="' + tracks[i].name + '">' + tracks[i].name + '</div>';
            }
        }

        $('<div style="display: none;" id="track_chooser"><div class="track-header">Choose track...</div>' + tracklist + '</div>').appendTo(this.$gpxForm).slideDown('fast');

        $('.trackname').on('click', function(event) {
            var chosenTrack = $(event.target).data('id');
            var chosenTrackName = $(event.target).data('name');
            var that = this;

            this.$gpxForm.find('#track_chooser').slideUp('fast', function() {
                $(this).remove();
                that.gpxDataChosen.notify({
                    id: chosenTrack
                });
            });

            $('<div style="display: none;" class="chosen-track"><span>Track: <b>' + chosenTrackName + '</b></span><div class="change-track">Change track</div></div>').appendTo(this.$gpxForm).slideDown('fast');

            $('.change-track').on('click', function(e) {
                this.showTrackChooser(tracks);
            }.bind(this));
            event.preventDefault();
        }.bind(this));
    };

    /**
     * remove DOM elements
     */
    GpxView.prototype.cleanUp = function() {
        this.$gpxForm.find('#track_chooser').slideUp('fast', function() {
            $(this).remove();
        });
        this.$gpxForm.find('.chosen-track').slideUp('fast', function() {
            $(this).remove();
        });
    };

    namespace.GpxView = GpxView;

})(window, app);