/**
 * gpx_controller.js
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

    /**
     * GpxController with gpxModel and gpxView
     * @param gpxModel
     * @param gpxView
     * @constructor
     */
    var GpxController = function(gpxModel, gpxView) {

        "use strict";

        this._model = gpxModel;
        this._view = gpxView;

        this._view.gpxDataLoad.register(function(sender, data) {
            this.loadGpxData(data.args);
        }.bind(this));

        this._view.gpxDataChosen.register(function(sender, data) {
            this._model.chooseTrack(data.id);
        }.bind(this));

        this._model.gpxDataLoadFailed.register(function(sender, data) {
            for (var i = 0; i < data.errors.length; i++) {
                this._view.$gpxForm.prepend('<p class="error">' + data.errors[i] + '</p>')
            }
        }.bind(this));

        this._model.gpxDataParsed.register(function(sender, data) {
            this._view.showTrackChooser(data.gps);
        }.bind(this));
    };

    /**
     * notify model about new gpx file in view.
     */
    GpxController.prototype.loadGpxData = function(data) {
        this._model.readGpxFile(data);
    };

    namespace.GpxController = GpxController;

})(window, app);