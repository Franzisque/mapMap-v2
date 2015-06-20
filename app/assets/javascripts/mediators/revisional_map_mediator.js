/**
 * revisional_map_mediator.js
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

    /**
     * work as main to instantiate objects necessary for
     * videos/new- and videos/edit views and as
     * mediator for parameter exchange
     * @param mapId
     * @param $searchBar
     */
    function initialize(mapId, $searchBar) {
        var mapModel = new app.Map(mapId);
        var mapView = new app.MapView(mapModel, $searchBar);
        new app.MapController(mapModel, mapView);

        var marker = new app.Marker({
            map: mapModel.mapControls,
            draggable: true,
            visible: false,
            icon: "/assets/main_marker.png"
        });
        var markerView = new app.MarkerView(marker);
        new app.MarkerController(markerView, marker);
        marker.setMarker();

        new app.VideoView();

        var trackModel = new app.Track(mapModel.mapControls);
        var trackView = new app.TrackView(trackModel, app.Button);
        var trackController = new app.TrackController(trackModel, trackView);

        var gpxModel = 0;
        var gpxView = 0;
        /**
         * only create gpx-logic if user clicks into input field for gpx-file upload
         */
        $('.gpx_file_input').one('click', function() {
            gpxModel = new app.Gpx();
            gpxView = new app.GpxView(gpxModel, $('#gpx_upload'), 'gpx_input');
            new app.GpxController(gpxModel, gpxView);

            gpxModel.trackIdChanged.register(function(sender, trackId) {
                trackModel.deleteTrack(trackId.id);
            });

            gpxModel.gpxDataLoaded.register(function(sender, data) {
                trackController.getGPXData(data.gps);
            });
        });

        /**
         * working as bridge between mapModel and markerController
         */
        var placeHasChanged = new ChangeEvent(this);

        function updatePlace(place) {
            trackView.setSearchMarkerPosition(place);
            trackModel.updateCircleToMarker(place);
            trackController.getFirstTrackPoint(place);
            marker.setMarkerToPlace(place);
        }

        /**
         * notify if something is searched in the search-bar
         */
        mapModel.placeChanged.register(function(sender, args) {
            updatePlace(args.place);
        });

        /**
         * notify about start-location if user agrees to reveal his location
         */
        mapModel.userLocationReceived.register(function(sender, userLocation) {
            if (!marker.marker.visible) {
                mapModel.mapControls.setCenter(userLocation.location);
                trackView.setSearchMarkerPosition(userLocation.location);
                trackController.getFirstTrackPoint(userLocation.location);
                marker.setMarkerToPlace(userLocation.location);
            }
        });

        /**
         * notify view to watch circles if model produces new ones
         */
        trackModel.trackPointsChanged.register(function(sender, point) {
            trackView.watchCircle(point.trackPoint);
        });

        trackModel.trackPointsDrawn.register(function(sender, trackPoints) {
            marker.setMarkerToPlace(trackPoints[0]);
            mapModel.setMapToRoute(trackPoints);
        });

        trackModel.markerDraggability.register(function(sender, markerDragState) {
            marker.triggerMarkerDraggable(!markerDragState);
        });

        mapView.zoomChanged.register(function(sender, zoom) {
            trackModel.adaptCirclesToMapZoom(zoom.zoomIntensity);
        });

        /**
         * set first track-circle to marker.
         * Update first circle if marker-position changes
         */
        marker.markerMoved.register(function(sender, point) {
            /**
             * necessary to update first point if marker gets dragged before
             * draw-track button is clicked
             */
            trackView.setSearchMarkerPosition(point.pointAttr);
            trackController.getFirstTrackPoint(point.pointAttr);
            trackModel.updateCircleToMarker(point.pointAttr);
        });

        trackView.markerToFirstCircle.register(function(sender, firstCircle) {
            marker.setMarkerToPlace(firstCircle.center);
        });

        trackView.trackSent.register(function(sender, data) {
            if (imageUploadView != undefined) {
                imageUploadView.submit(data.event, data.trackData);
            }
        });

        app.buttonClicked.register(function(sender, buttontext) {
            app.viewHelper.displayUserFeedback(buttontext.buttonText);
        });

        if (mapId === 'media-edit-map') {
            var mediaId = $('#media-edit').data('id');
            $.getJSON("/resources/" + mediaId + ".json", function(data) {
                marker.triggerMarkerDraggable(true);
                trackModel.setTrackPoints(data.tracks, true);
            }.bind(this));
        } else {
            /**
             * only consider user-location on track-creation
             */
            mapModel.getUserLocation();
        }
    }

    if ($('#media-create-map').length > 0) {
        initialize('media-create-map', $('#location'));
    }

    $('#edit-track-btn').on('click', function() {
        setTimeout(function() {
            initialize('media-edit-map', $('#location'));
        }, 100)
    });

    /**
     * initialize the different uploadView depending on which element is present
     */
    if ($('input[type="file"].new-album-file-field').length > 0) {
        var imageUploadView = new app.UploadView('image', $('input[type="file"].new-album-file-field'), '/resource_steps/tracking');
    }

    if ($('input[type="file"].video-file-field').length > 0) {
        var imageUploadView = new app.UploadView('video', $('input[type="file"].video-file-field'), '/resource_steps/tracking');
    }

    if ($('input[type="file"].edit-album-file-field').length > 0) {
        var id = $('#media-edit').data('id');
        var imageUploadView = new app.UploadView('image', $('input[type="file"].edit-album-file-field'), '/resources/' + id);
    }
});