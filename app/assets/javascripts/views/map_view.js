/**
 * map_view.js
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
     * @param mapModel
     * @param $inputField
     * @constructor
     */
    var MapView = function(mapModel, $inputField) {
        this.$inputField = $inputField;
        this.mapControls = mapModel.mapControls;
        this.autoComplete = 0;
        this.locationUpdated = new ChangeEvent(this);
        this.zoomChanged = new ChangeEvent(this);
        this.mapChanged = new ChangeEvent(this);
        this.checkInputField();
        this.watchMapZoom();
        this.addEvents();
    };

    MapView.prototype.addEvents = function() {
        var that = this;
        google.maps.event.addListener(this.mapControls, 'tilesloaded', function() {
            setTimeout(function() {
                that.mapChanged.notify({
                    zoom: that.mapControls.getZoom()
                });
            }, 200);
        });

        google.maps.event.addListener(this.mapControls, 'dragend', function() {
            that.mapChanged.notify({
                zoom: that.mapControls.getZoom()
            });
        });
    };

    /**
     * notify subjects registered for zoom-change, mostly the track-model
     * to adapt the track-circles to the zoom-intensity of the map
     */
    MapView.prototype.watchMapZoom = function() {
        google.maps.event.addListener(this.mapControls, 'zoom_changed', function() {
            var zoom = this.mapControls.getZoom();
            if (zoom > 15) {
                this.zoomChanged.notify({
                    zoomIntensity: zoom
                });
            }
        }.bind(this));
    };

    /**
     * initialise functions if input field exists
     */
    MapView.prototype.checkInputField = function() {
        if (this.$inputField) {
            this.initAutoCompletion();
            this.updatePlace();
        }
    };

    /**
     * create new autoComplete and bind it to mapControls
     */
    MapView.prototype.initAutoCompletion = function() {
        this.autoComplete = new google.maps.places.Autocomplete(this.$inputField[0]);
        this.autoComplete.bindTo('bounds', this.mapControls);
    };

    /**
     * get place returned by the autoCompletion. Check if it has only a name attribute.
     * if so, the user did not specify a place - call setDefaultSearchResult-function.
     */
    MapView.prototype.updatePlace = function() {
        google.maps.event.addListener(this.autoComplete, 'place_changed', function() {
            var place = this.autoComplete.getPlace();
            if (!place.geometry) {
                this.setDefaultSearchResult();
            }
            this.locationUpdated.notify({
                placeArgs: place
            });
        }.bind(this));
    };

    /**
     * ensure that first autoCompletion is the fallback for the search if nothing
     * gets selected by the user
     */
    MapView.prototype.setDefaultSearchResult = function() {
        google.maps.event.trigger(this.$inputField[0], 'keydown', {
            keyCode: 40
        });
        google.maps.event.trigger(this.$inputField[0], 'keydown', {
            keyCode: 13,
            triggered: true
        });
    };

    namespace.MapView = MapView;

})(window, app);