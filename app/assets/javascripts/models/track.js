/**
 * track.js
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
     * track-model with its properties
     * @param mapControls
     * @constructor
     */
    var Track = function(mapControls) {
        this.mapControls = mapControls;
        this.trackLine = 0;
        this.trackCircles = [];
        this.trackCoordinates = [];
        this.deleteCircleIcon = [];
        this.trackPointsExistent = false;
        this.elevator = new google.maps.ElevationService();
        this.circleExistance = new ChangeEvent(this);
        this.trackPointsChanged = new ChangeEvent(this);
        this.trackPointsDrawn = new ChangeEvent(this);
        this.markerDraggability = new ChangeEvent(this);
        this.processed = new ChangeEvent(this);
        this.elevationProcessed = new ChangeEvent(this);

        this.circleOptions = {
            map: this.mapControls,
            radius: 30,
            fillColor: '#F87F6E',
            fillOpacity: 1,
            strokeColor: '#F87F6E',
            strokeOpacity: 0.8,
            strokeWeight: 2,
            draggable: true,
            editable: false, // resizable
            scale: 20 //pixels
        };

        this.trackOptions = {
            strokeColor: '#F87F6E',
            strokeOpacity: 1.0,
            strokeWeight: 3
        };
    };

    /**
     * store circles in array.
     * This array will be pushed into two-dimensional array.
     * Necessary to conduct the tracks
     */
    Track.prototype.setTrackPoints = function(trackCoordinates, draggable) {
        if (this.trackCoordinates.length) {
            this.trackCoordinates = [];
        }

        /**
         * indicator weather circles should be draggable or not
         * default behaviour is that circles are draggable
         * @type {*|boolean}
         */
        var trackArr = [];
        for (var i = 0; i < trackCoordinates.length; i++) {
            trackArr[i] = new google.maps.LatLng(trackCoordinates[i].A, trackCoordinates[i].F);
            this.setCircleOptions(trackArr[i], draggable);
        }
        this.trackPointsDrawn.notify(trackArr);
    };

    /**
     * receive track-point-object from the point, the user has clicked on.
     * @param newTrackPoint
     */
    Track.prototype.setTrackManually = function(newTrackPoint) {
        this.mapControls.panTo(newTrackPoint);
        this.setCircleOptions(newTrackPoint, true);
    };

    /**
     * set the options of the track-circles i.e. the center and the
     * weather the track-point should be draggable or not.
     * Store the track-coordinates in an array
     * @param newTrackPoint
     * @param draggable
     */
    Track.prototype.setCircleOptions = function(newTrackPoint, draggable) {
        this.circleOptions.draggable = draggable;
        this.circleOptions.center = newTrackPoint;
        this.trackCoordinates.push(newTrackPoint);
        this.createCircle();
    };

    /**
     * create a new track-circle, assign an id to it and push it
     * into an circle-array. Set the track-line joining the circles
     */
    Track.prototype.createCircle = function() {
        var circle = new google.maps.Circle(this.circleOptions);
        circle.id = this.trackCircles.length;

        this.trackCircles.push(circle);
        this.notifyOnCircleChange(circle);

        this.setTrackLine(this.trackCoordinates);
    };

    /**
     * create a track-line and set it to the map.
     * Trigger function that is responsible for checking the existence
     * of the track
     * @param trackCoordinates
     */
    Track.prototype.setTrackLine = function(trackCoordinates) {
        if (this.trackLine) {
            this.deleteTrackLine();
        }
        this.trackLine = new google.maps.Polyline(this.trackOptions);
        this.trackLine.setPath(trackCoordinates);
        this.trackLine.setMap(this.mapControls);
        this.observeTrackCoordinates(trackCoordinates);
    };

    /**
     * set visibility if the whole track (track-line and -circles)
     * @param visible
     */
    Track.prototype.setVisible = function(visible) {
        this.trackLine.setVisible(visible);

        for (var i = 0; i < this.trackCircles.length; i++) {
            this.trackCircles[i].setVisible(visible);
        }
    };

    /**
     * notify track view only if trackCoordinates array gets filled or cleared.
     * Necessary for delete-button in track-view. Ensures that the button always
     * shows and behaves according to the right state.
     * @param trackCoordinates
     */
    Track.prototype.observeTrackCoordinates = function(trackCoordinates) {
        if (trackCoordinates.length && !this.trackPointsExistent) {
            this.trackPointsExistent = true;
            this.circleExistance.notify({
                existenceState: this.trackPointsExistent
            });
        }
    };

    /**
     * takes always the last entry of the two dimensional array.
     * Should be replaced with actual index of the track-line!
     * @param newPoint
     */
    Track.prototype.updateCircleToMarker = function(newPoint) {
        if (this.trackCircles.length) {
            this.trackCircles[0].setCenter(newPoint);
            this.updateTrack(this.trackCircles[0]);
        }
    };

    /**
     * notify interested subjects when the track-points have changed
     * @param circle
     */
    Track.prototype.notifyOnCircleChange = function(circle) {
        this.trackPointsChanged.notify({
            trackPoint: circle
        });
    };

    /**
     * change track-coordinates if track-point gets dragged to
     * an other position. Rebuilt track-line to be drawn according
     * to the new circle-position.
     * @param changedCircle
     */
    Track.prototype.updateTrack = function(changedCircle) {
        this.trackCoordinates[changedCircle.id] = changedCircle.center;
        this.setTrackLine(this.trackCoordinates);
    };

    /**
     * calculate the size of the track-circles according to the zoom-level -
     * take the zoomIntensity and subtract 14 - because this function gets called
     * only if the zoomIntensity is higher than 15 it starts with 1, than 2 etc.
     * After this calculation the number gets "exponentiated" with 1.5 and rounded
     * @param zoomIntensity
     */
    Track.prototype.adaptCirclesToMapZoom = function(zoomIntensity) {
        if (zoomIntensity >= 15) {
            for (var i = 0; i < this.trackCircles.length; i++) {
                var factor = Math.floor(Math.pow((zoomIntensity - 14), 1.5));
                var radius = 50 / factor;
                this.trackCircles[i].setRadius(radius);
            }
            this.circleOptions.radius = radius;
        }
    };

    /**
     * delete the track-line on the map and reset variable
     */
    Track.prototype.deleteTrackLine = function() {
        this.trackLine.setMap(null);
        this.trackLine = 0;
    };

    /**
     * If the deletion-state is true, the delete-icons should be set
     * on each circle. If the deletion-state is false, the track-circles
     * are movable and the delete-circle-icons get deleted
     * @param state
     * @returns {*}
     */
    Track.prototype.showDeleteCircleIcon = function(state) {
        this.markerDraggability.notify(state);
        if(state) {
            return this.newDeleteCircleIcons();
        }
        this.trackCircles.forEach(function(circle) {
            circle.draggable = true;
        });
        return this.deleteDeleteCircleIcon();
    };

    /**
     * create new delete-circle-icons with certain properties.
     * Set track-circles to an unmovable state.
     * @returns {Array}
     */
    Track.prototype.newDeleteCircleIcons = function() {
        this.deleteCircleIcon = [];
        this.trackCircles.forEach(function(circle){

            this.deleteCircleIcon.push(new google.maps.Marker({
                position: circle.center,
                id: circle.id,
                map: this.mapControls,
                title: 'delete circle',
                icon: this.createDeleteCircleImages("/assets/icon-delete.png")
            }));

            circle.draggable = false;

        }.bind(this));
        return this.deleteCircleIcon;
    };

    /**
     * delete the icons that were created to delete the circles.
     * @returns {number}
     */
    Track.prototype.deleteDeleteCircleIcon = function() {
        this.deleteCircleIcon.forEach(function(deleteCircleIcon) {
            deleteCircleIcon.setMap(null);
        }.bind(this));
        return 0;
    };

    /**
     * create an object for the delete-circle-pictures to display them and
     * position them on the track-circles.
     * @param imgUrl
     * @returns {{url: *, size: google.maps.Size, origin: google.maps.Point,
     * anchor: google.maps.Point}}
     */
    Track.prototype.createDeleteCircleImages = function(imgUrl) {
        return {
            url: imgUrl,
            size: new google.maps.Size(20, 20),
            origin: new google.maps.Point(0, 0),
            anchor: new google.maps.Point(10, 10)
        };
    };

    /**
     * delete one track-circle. Splice the adequate circle
     * from the array and assign the ids according to their
     * new position. Adapt the track-line to the new track-points
     */
    Track.prototype.deleteSingleCircle = function(circleId) {
        if (!circleId) {
            this.wholeTrackIsGone();
            return;
        }
        this.trackCircles[circleId].setMap(null);
        this.deleteCircleIcon[circleId].setMap(null);
        this.trackCircles.splice(circleId, 1);
        this.deleteCircleIcon.splice(circleId, 1);
        if (circleId < this.trackCircles.length) {
            this.setNewIds();
        }
        this.trackCoordinates.splice(circleId, 1);
        this.setTrackLine(this.trackCoordinates);
    };

    /**
     * reset and delete all dependencies if the first track-circle gets
     * deleted
     */
    Track.prototype.wholeTrackIsGone = function() {
        this.deleteTrackLine();
        this.deleteTrack(0);
        this.deleteDeleteCircleIcon();
        this.trackCoordinates = [];
        this.trackPointsExistent = false;
        this.circleExistance.notify({
            existenceState: this.trackPointsExistent
        });
    };

    /**
     * set the ids for the delete-circle-icons
     */
    Track.prototype.setNewIds = function() {
        for (var i = 0; i < this.trackCircles.length; i++) {
            this.trackCircles[i].id = i;
            this.deleteCircleIcon[i].id = i;
        }
    };

    /**
     * delete whole track if new gpx-track gets uploaded or if the
     * first track-circle gets deleted
     * @param trackId
     */
    Track.prototype.deleteTrack = function(trackId) {
        if (typeof trackId === 'number') {
            this.trackCircles.forEach(function(trackCircle) {
                trackCircle.setMap(null);
            });
            this.trackCircles = [];
        }
    };

    Track.prototype.processData = function(trackData, trackArray) {
        for (var i = 0; i < trackArray.length; i++) {
            trackData.resource.tracks_attributes[i] = {};
            trackData.resource.tracks_attributes[i].latitude = trackArray[i].lat();
            trackData.resource.tracks_attributes[i].longitude = trackArray[i].lng();
        }
        if (trackArray.length >= 2) {
            trackData.resource.distance = this.calculateTrackLength(trackArray);
            this.calculateTrackAltitudeDifference(trackArray);
        }
        this.processed.notify({
            trackData: trackData
        });
    };

    Track.prototype.calculateTrackLength = function(track) {
        var trackLength = 0;
        var tmpPoint = new google.maps.LatLng(track[0].lat(), track[0].lng());
        for (var i = 0; i < track.length - 1; i++) {
            var secondPoint = new google.maps.LatLng(track[i + 1].lat(), track[i + 1].lng());

            trackLength += google.maps.geometry.spherical.computeDistanceBetween(tmpPoint, secondPoint);

            tmpPoint = secondPoint;
        }
        return Math.round(trackLength * 100) / 100;
    };

    Track.prototype.calculateTrackAltitudeDifference = function(track) {
        var path = [];
        var samples = (track.length >= 25) ? 250 : track.length * 10;

        for (var i = 0; i < track.length; i++) {
            path[i] = new google.maps.LatLng(track[i].lat(), track[i].lng());
        }

        var pathRequest = {
            'path': path,
            'samples': samples
        };

        this.elevator.getElevationAlongPath(pathRequest, this.elevationCallback.bind(this));
    };

    Track.prototype.elevationCallback = function(results, status) {
        if (status != google.maps.ElevationStatus.OK) {
            return 0;
        }

        var difference = {
            up: 0,
            down: 0
        };

        for (var i = 0; i < results.length - 1; i++) {
            var actual = results[i].elevation;
            var next = results[i + 1].elevation;

            if (next >= actual) difference.up += (next - actual);
            else difference.down += (actual - next);
        }
        difference.up = Math.round(difference.up * 100) / 100;
        difference.down = Math.round(difference.down * 100) / 100;

        var data = {
            resource: {
                altitude_down: difference.down,
                altitude_up: difference.up
            }
        };

        this.elevationProcessed.notify({
            data: data
        });
    };

    namespace.Track = Track;

})(window, app);