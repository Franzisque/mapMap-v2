/**
 * show_map_mediator.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

$(document).ready(function() {

    "use strict";

    function initialize(mapId) {
        var mapModel = new app.Map(mapId);
        var trackModel = new app.Track(mapModel.mapControls);
        var searchMarker = new app.Marker({
            map: mapModel.mapControls,
            draggable: false,
            icon: "/assets/main_marker.png"
        });

        searchMarker.setMarker();

        /**
         * create map-view for the zoom adaption of the track-circles
         */
        var mapView = new app.MapView(mapModel, 0);

        trackModel.trackPointsDrawn.register(function(sender, trackPoints) {
            mapModel.setMapToRoute(trackPoints);
        });

        mapModel.placeChanged.register(function(sender, args) {
            searchMarker.setMarkerToPlace(args.place);
        });

        mapView.zoomChanged.register(function(sender, zoom) {
            trackModel.adaptCirclesToMapZoom(zoom.zoomIntensity);
        });

        /**
         * process data between the different sites of mapMap.
         * Read id from DOM-element and set the track-points
         * with the received data
         */
        var mediaId = $('#media-show').data('id');
        $.getJSON("/resources/" + mediaId + ".json", function(data) {
            if (data.tracks.length > 1) {
                trackModel.setTrackPoints(data.tracks, false);
            } else {
                // just display marker if there is only one track-point
                var tmp = new google.maps.LatLng(data.tracks[0].A, data.tracks[0].F);
                trackModel.trackPointsDrawn.notify([tmp]);
            }
        }.bind(this));
    }

    if ($('#media-map').length > 0) {
        initialize('media-map');
    }
});