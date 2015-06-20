/**
 * marker_list.js
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
     * handle markerlist logic
     * @param mapControls
     * @constructor
     */
    var MarkerList = function(mapControls) {

        this.mapControls = mapControls;

        this.markers = [];
        this.markerArr = [];
        this.markerIdx = 0;

        this.trackToDraw = new ChangeEvent(this);
        this.markerHoverIn = new ChangeEvent(this);
        this.markerHoverOut = new ChangeEvent(this);
        this.markerClick = new ChangeEvent(this);
    };

    /**
     * hide all infowindows except the given
     */
    MarkerList.prototype.hideOtherInfoWindows = function(except_id) {
        for (var i = 0; i < this.markerArr.length; i++) {
            if (i != except_id) this.markerArr[i].info.close();
        }
    };

    /**
     * delete all markers
     */
    MarkerList.prototype.clearMarkers = function() {
        for (var i = 0; i < this.markers.length; i++) {
            this.markers[i].model.clearMarker();
        }
        this.markers = [];
        this.markerArr = [];
        this.markerIdx = 0;
    };

    /**
     * add new RichMarker to the list
     */
    MarkerList.prototype.addRichMarker = function(coordinates, id, url, draggable) {
        var marker = {};
        marker.model = new app.Marker({
            map: this.mapControls,
            id: this.markerIdx,
            coordinates: coordinates,
            draggable: draggable
        });
        marker.view = new app.MarkerView(marker.model);
        marker.controller = new app.MarkerController(marker.view, marker.model);
        marker.model.setRichMarker();
        marker.model.addInfoWindow('<a href="' + url + '">Link to Resource</a>');

        marker.view.markerHover.register(function(sender, data) {
            this.markerHoverIn.notify({
                id: data.id
            });
            this.hideOtherInfoWindows(data.id);
        }.bind(this));
        marker.view.markerHoverOut.register(function(sender, data) {
            this.markerHoverOut.notify({
                id: data.id
            });
        }.bind(this));
        marker.view.markerClick.register(function(sender, data) {
            this.markerClick.notify({
                id: data.id
            });
            this.hideOtherInfoWindows(data.id);
        }.bind(this));

        this.markers[this.markerIdx] = marker;
        this.markerArr[this.markerIdx] = marker.model.marker;
        this.markerIdx++;
    };

    /**
     * set visibility for all markers in this list except the one with the given id
     */
    MarkerList.prototype.setVisibility = function(trackId, visible) {
        for (var i = 0; i < this.markers.length; i++) {
            if (i != trackId) this.markers[i].model.setVisibility(visible);
        }
    };

    /**
     * load the data for the given resources
     */
    MarkerList.prototype.getVideos = function(data) {
        this.clearMarkers();
        var videos = data.resources;
        for (var i = 0; i < videos.length; i++) {
            this.getSingleVideo(videos[i].tracks, i, videos[i].url);
        }
    };

    /**
     * load a single resource data and add its marker
     */
    MarkerList.prototype.getSingleVideo = function(data, i, url) {
        this.trackToDraw.notify({
            gps: data,
            id: i
        });

        var videoCoordinates = new google.maps.LatLng(data[0].A, data[0].F);

        this.addRichMarker(videoCoordinates, i, url, false);
    };


    namespace.MarkerList = MarkerList;

})(window, app);