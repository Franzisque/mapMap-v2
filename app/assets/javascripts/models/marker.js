/**
 * marker.js
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
     * handle marker logic
     * @param options
     * @constructor
     */
    var Marker = function(options) {
        this.mapControls = options.map;
        this.draggable = options.draggable || false;
        this.coordinates = options.coordinates || new google.maps.LatLng(47.80949, 13.05501);
        this.id = options.id || 0;
        this.icon = options.icon || 0;
        this.visible = options.visible == false ? false : true;

        this.marker = 0;

        this.locationChanged = new ChangeEvent(this);
        this.markerSet = new ChangeEvent(this);
        this.markerMoved = new ChangeEvent(this);
    };

    Marker.prototype.setMarkerToPlace = function(place) {
        this.marker.position = place;
        this.marker.setVisible(true);
        this.locationChanged.notify({
            place: this.place
        });
    };

    Marker.prototype.triggerMarkerDraggable = function(markerDragState) {
        this.marker.setDraggable(markerDragState);
    };

    Marker.prototype.getDraggable = function() {
        return this.marker.getDraggable();
    };

    /**
     * delete this marker
     */
    Marker.prototype.clearMarker = function() {
        this.marker.setMap(null);
    };

    /**
     * et visibility of this marker
     * @param visible
     */
    Marker.prototype.setVisibility = function(visible) {
        this.marker.setVisible(visible);
        this.visible = visible;
    };

    /**
     * add infowindow to marker
     * @param data
     */
    Marker.prototype.addInfoWindow = function(data) {
        if (this.marker != 0) {
            this.marker.info = new google.maps.InfoWindow({
                content: data,
                pixelOffset: new google.maps.Size(0, -50)
            });
        }
    };

    /**
     * configure this marker as richmarker
     */
    Marker.prototype.setRichMarker = function() {
        this.marker = new RichMarker({
            map: this.mapControls,
            draggable: this.draggable,
            position: this.coordinates,
            shadow: 0,
            id: this.id,
            visible: this.visible,
            content: '<div class="rich-marker"><span class="marker-number">' + (this.id + 1) + '</span><img class="numbered-marker" src="/assets/numbered_marker.png"></div>',
            animation: google.maps.Animation.DROP,
            anchor: RichMarkerPosition.BOTTOM
        });

        this.markerSet.notify();
    };

    /**
     * configure this marker as normal marker
     */
    Marker.prototype.setMarker = function() {
        this.marker = new google.maps.Marker({
            map: this.mapControls,
            draggable: this.draggable,
            position: this.coordinates,
            id: this.id,
            visible: this.visible,
            animation: google.maps.Animation.DROP,
            anchorPoint: new google.maps.Point(0, -29)
        });

        if (this.icon != 0) {
            this.setSearchIcon();
        }

        this.markerSet.notify();
    };

    /**
     * set icon if it is given and a few other settings such as size, url etc.
     */
    Marker.prototype.setSearchIcon = function() {
        this.marker.setIcon(({
            url: this.icon,
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(19, 57),
            scaledSize: new google.maps.Size(38, 57)
        }));
    };

    /**
     * get latitude and longitude of places marker
     * @param marker
     */
    Marker.prototype.getMarkerPosition = function(marker) {
        var point = marker.markerAttr.getPosition();
        this.markerMoved.notify({
            pointAttr: point
        })
    };

    namespace.Marker = Marker;

})(window, app);