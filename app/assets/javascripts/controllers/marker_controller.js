/**
 * marker_controller.js
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
     * receive data input from the view and deliver it to model
     * @param view
     * @param model
     * @constructor
     */
    var MarkerController = function(view, model) {
        this._view = view;
        this._model = model;

        this._view.markerDragend.register(function(sender, marker) {
            this.getGeoPosition(marker);
        }.bind(this));

        this._model.markerSet.register(function(sender, data) {
            this._view.addEvents();
        }.bind(this));
    };

    /**
     * send marker to marker model.
     */
    MarkerController.prototype.getGeoPosition = function(marker) {
        this._model.getMarkerPosition(marker);
    };

    namespace.MarkerController = MarkerController;

})(window, app);