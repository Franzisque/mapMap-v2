/**
 * track_controller.js
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
     * MapController with mapModel and mapView
     * @param trackModel
     * @param trackView
     * @constructor
     */
    var TrackController = function(trackModel, trackView) {

        this._model = trackModel;
        this._view = trackView;
        this.firstTrackPoint = 0;

        /**
         * update track if the circle gets dragged
         */
        this._view.circlePositionChanged.register(function(sender, movedCircleArgs) {
            this._model.updateTrack(movedCircleArgs.circlePoints);
        }.bind(this));

        /**
         * process th track-line data to different sites if mapMap
         */
        this._view.toProcess.register(function(sender, data) {
            this._model.processData(data.trackData, data.track);
        }.bind(this));

        /**
         * forward data to the model if the user draws the track manually
         * by clicking on tha map
         */
        this._view.trackPointSet.register(function(sender, newTrackPoint) {
            this._model.setTrackManually(newTrackPoint.position);
        }.bind(this));

        /**
         * hold back the track-drawing until it is allowed to be set -
         * important to set the first circle only ig the user clicks on
         * the draw-track button
         */
        this._view.firstPointToMarker.register(function(sender, drawState) {
            if (drawState.allowSettling && this.firstTrackPoint) {
                this._model.setTrackManually(this.firstTrackPoint);
            }
        }.bind(this));

        /**
         * display the delete-circle-icons if the user clicks the delete-track-button
         */
        this._view.showDeleteIcon.register(function(sender, state) {
            var deleteCircleIcon = this._model.showDeleteCircleIcon(state.ShowState);
            this._view.watchNewDeleteCircleIcon(deleteCircleIcon);
        }.bind(this));

        /**
         * send back track-data after dealing with them in the model
         */
        this._model.processed.register(function(sender, data) {
            this._view.afterProcess(data.trackData);
        }.bind(this));

        /**
         * send altitude-data to display it on the track-view
         */
        this._model.elevationProcessed.register(function(sender, data) {
            this._view.sendAltitudeDifference(data.data);
        }.bind(this));

        /**
         * notify the model about the id of the circle that should be deleted.
         */
        this._view.deleteSingleCircle.register(function(sender, circlePointId) {
            this._model.deleteSingleCircle(circlePointId.deleteCircleId);
        }.bind(this));

        /**
         * observe if circle is existent and call the according functions
         * if it ie existent or non-existent
         */
        this._model.circleExistance.register(function(sender, state) {
            this._view.deleteCircleBtnClicked(state.existenceState);
            this._view.resetDeleteButton(state.existenceState);
        }.bind(this));
    };

    /**
     * get first track-point.
     */
    TrackController.prototype.getFirstTrackPoint = function(firstTrackPoint) {
        this.firstTrackPoint = firstTrackPoint;
    };

    /**
     * delivers gpx-data to track-model
     */
    TrackController.prototype.getGPXData = function(data) {
        this._model.setTrackPoints(data, true);
    };

    namespace.TrackController = TrackController;

})(window, app);