/**
 * main_map_mediator.js
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
     * instantiate all the defined objects.
     * Work as mediator between certain "mvc-logics"
     * this means sending parameters i.e. from the marker-part
     * to to the video-part
     */
    function initialize() {
        var mapModel = new app.Map('main_map');
        var mapView = new app.MapView(mapModel, $('#location'));
        new app.MapController(mapModel, mapView);

        var searchMarker = new app.Marker({
            map: mapModel.mapControls,
            draggable: true,
            icon: "/assets/main_marker.png"
        });
        var markerView = new app.MarkerView(searchMarker);
        new app.MarkerController(markerView, searchMarker);
        searchMarker.setMarker();
        searchMarker.setVisibility(false);

        mapModel.placeChanged.register(function(sender, args) {
            searchMarker.setMarkerToPlace(args.place);
        });

        mapModel.userLocationReceived.register(function(sender, userLocation) {
            searchMarker.setMarkerToPlace(userLocation.location);
        });

        /**
         * set user location on main map - not relevant for every kind of map
         */
        mapModel.getUserLocation();

        /**
         * initialize filtering controller logic
         */
        if ($('#filter-form').length) {
            var markerList = new app.MarkerList(mapModel.mapControls);
            var filterModel = new app.Filter($('#filter-form'), mapModel.mapControls);
            var filterView = new app.FilterView(filterModel, $('#filter-form'), $('#filter-result'));
            var filterController = new app.FilterController(filterModel, filterView);

            var trackListModel = new app.TrackList(mapModel.mapControls);

            var markerCluster;

            /**
             * mapzoom or viewpoint changed -> update visible tracks and zoom
             */
            mapView.mapChanged.register(function(sender, data) {
                filterController.filterTracks();
                trackListModel.handleMapZoom(data.zoom);
            });

            /**
             * tracks got reloaded -> update visible tracks
             */
            filterModel.resourceLoaded.register(function(sender, data) {
                trackListModel.clearTracks();
                if (markerCluster != undefined) markerCluster.clearMarkers();

                markerList.getVideos(data);
                markerCluster = new MarkerClusterer(mapModel.mapControls, markerList.markerArr, app.markerClusterProps);
                markerCluster.setIgnoreHidden(true);
                trackListModel.handleMapZoom(mapModel.mapControls.getZoom());
            });

            /**
             * add track to tracklist if marker is added
             */
            markerList.trackToDraw.register(function(sender, data) {
                trackListModel.addTrack(data.gps, data.id);
            }.bind(this));

            /**
             * click on marker triggers highlighting of itself and the filterview
             */
            markerList.markerClick.register(function(sender, data) {
                if (data.id >= 0) {
                    filterView.highlightResource(data);
                }
            }.bind(this));

            /**
             * hover over marker triggers highlighting of the filterview
             */
            markerList.markerHoverIn.register(function(sender, data) {
                if (data.id >= 0) {
                    filterView.highlightResource(data);
                    trackListModel.setVisible(data.id, true);
                    markerList.setVisibility(data.id, false);
                    markerCluster.repaint();
                }
            }.bind(this));
            markerList.markerHoverOut.register(function(sender, data) {
                if (data.id >= 0) {
                    filterView.deHighlightResource(data);
                    trackListModel.setVisible(data.id, false);
                    markerList.setVisibility(data.id, true);
                    markerCluster.repaint();
                }
            }.bind(this));

            /**
             * hover over filterresult triggers the track to show and other markers to be invisible
             */
            filterView.hoverResultIn.register(function(sender, data) {
                trackListModel.setVisible(data.id, true);
                markerList.setVisibility(data.id, false);
                markerCluster.repaint();
            }.bind(this));
            filterView.hoverResultOut.register(function(sender, data) {
                trackListModel.setVisible(data.id, false);
                markerList.setVisibility(data.id, true);
                markerCluster.repaint();
            }.bind(this));
        }
    }

    if ($('#main_map').length > 0) {
        initialize();
    }
});