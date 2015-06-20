/**
 * track_list.js
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

    var TrackList = function(mapControls) {
        this.mapControls = mapControls;
        this.tracks = [];
        this.circleExistance = new ChangeEvent(this);
    };

    /**
     * add track to this list
     */
    TrackList.prototype.addTrack = function(track, pos) {
        var model = new app.Track(this.mapControls);
        var view = new app.TrackView(model, app.Button);
        var controller = new app.TrackController(model, view);

        this.tracks[pos] = {
            'model': model,
            'view': view,
            'controller': controller
        };
        this.tracks[pos].model.setTrackPoints(track, false);
        this.tracks[pos].model.setVisible(false);
    };

    /**
     * handle zoom for every track in this list
     */
    TrackList.prototype.handleMapZoom = function(zoomIntensity) {
        for (var i = 0; i < this.tracks.length; i++) {
            this.tracks[i].model.adaptCirclesToMapZoom(zoomIntensity);
        }
    };

    /**
     * delete all tracks in this list
     */
    TrackList.prototype.clearTracks = function() {
        for (var i = 0; i < this.tracks.length; i++) {
            this.tracks[i].model.deleteTrack(i);
            this.tracks[i].model.deleteTrackLine();
        }
        this.tracks = [];
    };

    /**
     * set visibility for all tracks in this list
     */
    TrackList.prototype.setVisible = function(trackId, visible) {
        /**
         * if there is only one trackCircle - don't display
         */
        if (this.tracks[trackId].model.trackCircles.length > 1) {
            this.tracks[trackId].model.setVisible(visible);
        }
    };

    namespace.TrackList = TrackList;

})(window, app);