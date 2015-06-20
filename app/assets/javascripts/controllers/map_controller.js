/**
 * map_controller.js
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
     * @param mapModel
     * @param mapView
     * @constructor
     */
    var MapController = function(mapModel, mapView) {

        this._model = mapModel;
        this._view = mapView;

        this._view.locationUpdated.register(function(sender, place) {
            this.updateLocation(place.placeArgs);
        }.bind(this));
    };

    /**
     * notify model about place changes in the view.
     * This happens if the user inserts a new place
     */
    MapController.prototype.updateLocation = function(place) {
        this._model.setLocation(place);
    };

    namespace.MapController = MapController;

})(window, app);