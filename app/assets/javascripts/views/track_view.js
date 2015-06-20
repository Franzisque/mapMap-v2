/**
 * track_view.js
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

    var TrackView = function(trackModel, Button) {
        this._model = trackModel;
        this.drawTrackBtn = new Button($('.draw-track-btn'), 'Draw Track');
        this.deleteCircleBtn = new Button($('.delete-circle-btn'), 'Delete Track-Point');
        this.formData = {};
        this.initDeleteBtn(this.deleteCircleBtn);
        this.searchMarkerPos = 0;
        this.mapControls = trackModel.mapControls;

        this.circlePositionChanged = new ChangeEvent(this);
        this.trackPointSet = new ChangeEvent(this);
        this.firstPointToMarker = new ChangeEvent(this);
        this.markerToFirstCircle = new ChangeEvent(this);
        this.showDeleteIcon = new ChangeEvent(this);
        this.deleteSingleCircle = new ChangeEvent(this);
        this.trackSent = new ChangeEvent(this);
        this.toProcess = new ChangeEvent(this);
        this.getTrackCoordinates();
        this.labelButton();
        this.preProcess();
        this.gpxUploadBtnClicked($('.track-edit-fields'));
    };

    /**
     * check for track-points, throw error if none found
     * @param event
     */
    TrackView.prototype.checkForTrackPoints = function(event) {
        if (!this._model.trackCoordinates.length && !this.searchMarkerPos) {
            $('.submit-error').slideUp('fast', function() {
                $(this).remove();
            });
            $('<div class="submit-error" style="display: none;">Atleast one Trackpoint has to be set.</div>')
                .prependTo('.actions').slideDown('fast', function() {
                setTimeout(function() {
                    $(this).slideUp('fast', function() {
                        $(this).remove();
                    });
                }.bind(this), 3000);
            });

            event.preventDefault();
        }
    };

    /**
     * collect data to create a new track
     */
    TrackView.prototype.preProcess = function() {
        $('#input_form_tracks').off('submit').on('submit', function(event) {
            // check if any track-points are set
            this.checkForTrackPoints(event);

            // set formData for future requests
            this.formData = {
                action: $('this').attr('action'),
                site: $(event.target).parent().parent().parent().attr('id'),
                type: $('#resource_medium_type').val(),
                event: event
            };

            this.process();
        }.bind(this));
    };

    /**
     * process the data for new tracks
     */
    TrackView.prototype.process = function() {
        var trackData = {
            resource: {
                tracks_attributes: {},
                distance: 0
            }
        };

        if (this._model.trackCoordinates.length) {
            this.toProcess.notify({
                trackData: trackData,
                track: this._model.trackCoordinates
            });
        } else {
            var searchMarkerPosition = [];
            searchMarkerPosition[0] = this.searchMarkerPos;

            this.toProcess.notify({
                trackData: trackData,
                track: searchMarkerPosition
            });
        }
    };

    /**
     * collect the processed data and set everything for the request
     * @param processedData
     */
    TrackView.prototype.afterProcess = function(processedData) {
        var data = {
            event: this.formData.event,
            id: 0,
            formData: 0,
            url: "",
            redirectUrl: ""
        };

        /**
         * check from which site the form is sent
         */
        if (this.formData.site === "edit-track" && this.formData.type === "Album") {
            this.trackSent.notify({
                trackData: processedData,
                event: this.formData.event
            });
        } else if (this.formData.site === "edit-track" && this.formData.type !== "Album") {
            data.id = $('#media-edit').data('id');
            data.formData = $('#edit_resource_' + data.id).serialize();

            data.url = "/resources/" + data.id;
            data.redirectUrl = "/resources/" + data.id;
            data.formData += '&' + $.param(processedData);

            this.sendRequest(data);
        } else {
            data.formData = $('#input_form_tracks').serialize();

            data.url = "/resource_steps/tracking";
            data.redirectUrl = "/resource_steps/wicked_finish";
            data.formData += '&' + $.param(processedData);

            this.sendRequest(data);
        }
    };

    /**
     * async request to write the new track to the database
     * @param data
     */
    TrackView.prototype.sendRequest = function(data) {
        data.event.preventDefault();

        $.ajax({
            type: 'POST',
            url: data.url,
            data: data.formData,
            success: function(result, status) {
                if (status == "success") {
                    $(location).attr('href', data.redirectUrl);
                }
            }
        });
    };

    /**
     * write the altitude difference to the database
     * @param data
     */
    TrackView.prototype.sendAltitudeDifference = function(data) {
        $.ajax({
            type: 'PUT',
            url: this.formData.action,
            data: data
        });
    };

    /**
     * manage button states of gpx-upload button gets clicked
     * @param $gpxOptions
     */
    TrackView.prototype.gpxUploadBtnClicked = function($gpxOptions) {
        $gpxOptions.on('click', function() {
            this.deleteCircleBtn.resetAllButtons(this.drawTrackBtn);
            this.drawTrackBtn.$element.off("click");
            this.drawTrackBtn.buttonClick("Stop Expanding");
            this.sparkFirstCircleSet();
        }.bind(this));
    };

    /**
     * initial button-initialisation of draw-track button
     */
    TrackView.prototype.labelButton = function() {
        this.drawTrackBtn.buttonClick("Stop Drawing");
        this.sparkFirstCircleSet();
    };

    /**
     * set initial state of the delete button - button does not change
     * state and displays am error message that no track-point exists
     * to be deleted.
     * @param button
     */
    TrackView.prototype.initDeleteBtn = function(button) {
        button.$element.text("Delete Track-Point");
        button.$element.click(function() {
            if (!$('.error').length) {
                $('.actions').prepend('<p class="error"> ' +
                    'Please draw a track or upload a gpx-file </p>');
            }
        });
    };

    /**
     * receive notification from track-model, if track-point exists
     * @param trackPointExistence
     */
    TrackView.prototype.resetDeleteButton = function(trackPointExistence) {
        if (!trackPointExistence) {
            this.deleteCircleBtn.resetButton();
            this.deleteCircleBtn.setActiveState(false);
            this.deleteCircleBtn.$element.off("click");
            this.initDeleteBtn(this.deleteCircleBtn);
        }
    };

    /**
     * handle the show- adn hide- functionality of the delete-circle-icons.
     * Only show the delete-button icons if the delete-circle button hast the
     * right state and if there are track-circles existent
     * @param trackPointExistence
     */
    TrackView.prototype.deleteCircleBtnClicked = function(trackPointExistence) {
        this.deleteCircleBtn.buttonClick("Stop Deleting");
        this.deleteCircleBtn.$element.on('click', function() {
            if (trackPointExistence && this.deleteCircleBtn.getActiveState()) {
                this.drawTrackBtn.resetButton();
                this.showDeleteIcon.notify({
                    ShowState: true
                });
            } else {
                this.showDeleteIcon.notify({
                    ShowState: false
                });
            }
        }.bind(this));

    };

    /**
     * update marker to circle-position
     * @param position
     */
    TrackView.prototype.setSearchMarkerPosition = function(position) {
        this.searchMarkerPos = position;
    };

    /**
     * spark the first track circle to be set, but only if the user clicks
     * on the draw-track-button
     */
    TrackView.prototype.sparkFirstCircleSet = function() {
        this.drawTrackBtn.$element.on('click', function() {
            if (!this._model.trackCoordinates.length) {
                this.firstPointToMarker.notify({
                    allowSettling: true
                });
            }
        }.bind(this));
    };


    /**
     * observe a track-circle if it get dragged. Set marker to first circle
     * if it gets dragged
     * @param actualCircle
     */
    TrackView.prototype.watchCircle = function(actualCircle) {
        google.maps.event.addListener(actualCircle, 'dragend', function() {
            this.circlePositionChanged.notify({
                circlePoints: actualCircle
            });
            if (actualCircle.id === 0) {
                this.markerToFirstCircle.notify({
                    center: actualCircle.center
                });
            }
        }.bind(this));
        this.callOnce(actualCircle);
    };

    /**
     * notify track-model if delete-circle icons get clicked so that the
     * according circle can be deleted
     * @param deleteCircleIcon
     */
    TrackView.prototype.watchNewDeleteCircleIcon = function(deleteCircleIcon) {
        if (deleteCircleIcon) {
            deleteCircleIcon.forEach(function(icon) {
                google.maps.event.addListener(icon, 'click', function() {
                    this.deleteSingleCircle.notify({
                        deleteCircleId: icon.id
                    });
                }.bind(this));
            }.bind(this));
        }
    };

    /**
     * set marker to first circle
     * @param actualCircle
     */
    TrackView.prototype.callOnce = function(actualCircle) {
        this.markerToFirstCircle.notify({
            center: actualCircle.center
        });
        this.callOnce = function() {};
    };

    /**
     * notify model if user clicks on the map so that the circles can
     * be set to the right position
     */
    TrackView.prototype.getTrackCoordinates = function() {
        google.maps.event.addListener(this.mapControls, "click", function(event) {
            if (this.drawTrackBtn.getActiveState()) {
                this.trackPointSet.notify({
                    position: event.latLng
                });
                this.deleteCircleBtn.resetButton();
            }
        }.bind(this));
    };

    namespace.TrackView = TrackView;

}(window, app));