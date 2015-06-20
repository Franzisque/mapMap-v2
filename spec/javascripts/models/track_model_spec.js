/**
 * track_model_spec.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

describe('TrackModel', function() {

    var trackModel;
    var mapModel;
    var trackCoordinates;
    var gMapsCoordinates = [];

    beforeEach(function() {
        mapModel = new app.Map('main_map');
        trackModel = new app.Track(mapModel.mapControls);


        trackCoordinates = [{
            A: "43.676189",
            F: "-116.161728"
        }, {
            A: "44.703636",
            D: "-120.106470"
        }, {
            A: "46.148087",
            F: "13.694515"
        }];

        trackCoordinates.forEach(function(coordinate) {
            gMapsCoordinates.push(new google.maps.LatLng(coordinate.A, coordinate.F));
        })
    });

    describe('test trackModel', function() {

        it('should set new trackCoordinates', function() {
            trackModel.setTrackPoints(trackCoordinates, true);
            expect(trackModel.trackCoordinates.length).toEqual(3);
        });

        it('should set circle to new center', function() {
            trackModel.setTrackPoints(trackCoordinates, true);
            trackModel.setCircleOptions(gMapsCoordinates[0], true);
            expect(trackModel.trackCircles[0].getCenter().lat()).toEqual(43.676189);
        });

        it('should set fix circle', function() {
            trackModel.setTrackPoints(trackCoordinates, false);
            var lastCircle = trackModel.trackCircles.length - 1;
            expect(trackModel.trackCircles[lastCircle].id).toEqual(2);
        });

        it('should be set visible', function() {
            trackModel.setTrackPoints(trackCoordinates, true);
            trackModel.setVisible(false);
            expect(trackModel.trackCircles[1].getVisible()).toBeFalsy();
        });

        it('should have set a track-path', function() {
            trackModel.setTrackLine(gMapsCoordinates);
            expect(trackModel.trackLine.getPath().j[0].lat()).toEqual(43.676189);
        });

        it('should indicate if track is existent', function() {
            trackModel.trackPointsExistent = false;
            trackModel.observeTrackCoordinates(trackCoordinates);
            expect(trackModel.trackPointsExistent).toBeTruthy();
        });

        it('should update circle to marker', function() {
            trackModel.setTrackPoints(trackCoordinates, true);
            trackModel.updateCircleToMarker(gMapsCoordinates[0]);
            expect(trackModel.trackCircles[2].getCenter().lat()).toEqual(46.148087);
        });

        it('should delete the whole track-line', function() {
            trackModel.setTrackPoints(trackCoordinates, true);
            trackModel.deleteTrackLine();
            expect(trackModel.trackLine).toEqual(0);
        });
    });
});