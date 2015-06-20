/**
 * map.js
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
     * index map with certain settings
     * @param mapId
     * @constructor
     */
    var Map = function(mapId) {

        this.handler = Gmaps.build('Google');
        this.mapOptions = this.handler.buildMap({
            internal: {
                id: mapId
            },
            provider: {
                styles: namespace.mapStyle, // custom map-styling
                zoom: 3, // zoom that shows the whole world-map
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                mapTypeControl: false,
                draggableCursor: 'auto',
                streetViewControl: false, // possibility to switch to street view
                panControl: false, // navigation circle in the upper left corner
                scaleControl: false,
                zoomControl: true,
                minZoom: 3,
                maxZoom: 18,
                zoomControlOptions: {
                    style: google.maps.ZoomControlStyle.DEFAULT,
                    position: google.maps.ControlPosition.LEFT_CENTER
                }
            }
        });

        this.mapControls = this.mapOptions.serviceObject;

        /**
         * change events for initial user location (with geoLocation)
         * and for general location changes
         * @type {ChangeEvent}
         */
        this.placeChanged = new ChangeEvent(this);
        this.userLocationReceived = new ChangeEvent(this);

        this.setDefaultLocation();
    };

    /**
     * set bounds of map in a way that centers the track.
     * This is only necessary if there is a single track
     * (e. g. in the show- and edit-view )
     * @param trackCoordinates
     */
    Map.prototype.setMapToRoute = function(trackCoordinates) {

        var bounds = new google.maps.LatLngBounds();

        for (var i = 0; i < trackCoordinates.length; i++) {
            bounds.extend(trackCoordinates[i]);
        }

        var center = bounds.getCenter();

        this.handleLocationInputs(center, trackCoordinates[0]);
        this.mapControls.fitBounds(bounds);
    };

    /**
     * set location if something gets inserted into search bar
     * @param place
     */
    Map.prototype.setLocation = function(place) {
        if (place.geometry) {
            this.handleLocationInputs(place.geometry.location, place.geometry.location);
        }
    };

    /**
     * set new location on the map and notify interested subjects about changed place
     * @param newMapCenter
     * @param newLocation
     */
    Map.prototype.handleLocationInputs = function(newMapCenter, newLocation) {
        this.setZoom(14);
        this.mapControls.setCenter(newMapCenter);
        this.placeChanged.notify({
            place: newLocation
        });
    };

    /**
     * set initial center of map to "Puch bei Hallein"
     */
    Map.prototype.setDefaultLocation = function() {
        var positionCoords = {
            latitude: 47.718757,
            longitude: 13.093237
        };
        this.handleInitialLocation(positionCoords);
    };

    /**
     * receive userLocation if user reveals the current location.
     * If there is no navigation, the browser does not support
     * geoLocation.
     */
    Map.prototype.getUserLocation = function() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                this.handleInitialLocation(position.coords);
                this.setZoom(14);
            }.bind(this));
            return;
        }
        alert("Your browser doesn't support geolocation.");
    };

    /**
     * set initial location - first for the map and if it is allowed,
     * also the users position.
     * @param positionCoords
     */
    Map.prototype.handleInitialLocation = function(positionCoords) {
        var initialLocation = new google.maps.LatLng(positionCoords.latitude, positionCoords.longitude);
        this.mapControls.setCenter(initialLocation);
        this.userLocationReceived.notify({
            location: initialLocation
        });
    };

    Map.prototype.setZoom = function(zoomIntensity) {
        this.mapControls.setZoom(zoomIntensity);
    };

    namespace.Map = Map;

})(window, app);