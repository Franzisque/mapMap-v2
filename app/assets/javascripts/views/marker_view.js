/**
 * marker_view.js
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
     * receive user input revering to the marker
     * deliver data to marker-list-controller
     * @param model
     * @param $element
     * @constructor
     */
    var MarkerView = function(model) {
        this._model = model;
        this.markerDragend = new ChangeEvent(this);
        this.markerHover = new ChangeEvent(this);
        this.markerHoverOut = new ChangeEvent(this);
        this.markerClick = new ChangeEvent(this);
    };

    /**
     * add events for click, hover and dragend to each marker
     */
    MarkerView.prototype.addEvents = function() {
        var that = this;

        google.maps.event.addListener(this._model.marker, 'click', function() {
            var id = this.id;
            if (this.info != undefined)
                that._model.marker.info.open(that._model.mapControls, this);
            that.markerClick.notify({
                id: id
            });
        });

        google.maps.event.addListener(this._model.marker, 'mouseover', function() {
            var id = this.id;
            that.markerHover.notify({
                id: id
            });
        });

        google.maps.event.addListener(this._model.marker, 'mouseout', function() {
            var id = this.id;
            that.markerHoverOut.notify({
                id: id
            });
        });

        google.maps.event.addListener(this._model.marker, 'dragend', function() {
            this.markerDragend.notify({
                markerAttr: this._model.marker
            });
        }.bind(this));
    };

    namespace.MarkerView = MarkerView;

})(window, app);