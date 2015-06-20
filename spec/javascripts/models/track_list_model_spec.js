/**
 * track_list_model_spec.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

describe('TrackListModel', function() {

    var trackListModel, mapModel, trackCoordinates;

    beforeEach(function() {
        mapModel = new app.Map('main_map');
        trackListModel = new app.TrackList(mapModel.mapControls);

        trackCoordinates = [{
            D: "-116.161728",
            k: "43.676189"
        }, {
            D: "-120.106470",
            k: "44.703636"
        }, {
            D: "46.148087",
            k: "13.694515"
        }];
    });

    describe('contructor', function() {

        it('should set tracks to empty array', function() {
            expect(trackListModel.tracks.length).toEqual(0);
        });
    });

    describe('test methods', function() {

        it('should add new track', function() {
            trackListModel.addTrack(trackCoordinates, 0);
            expect(trackListModel.tracks[0].model.trackCoordinates.length).toEqual(3);
        });

        it('should delete all tracks', function() {
            trackListModel.clearTracks();
            expect(trackListModel.tracks.length).toEqual(0);
        });

        it('should set zoom intensity', function() {
            trackListModel.addTrack(trackCoordinates, 0);
            trackListModel.handleMapZoom(15);
            expect(trackListModel.tracks[0].model.circleOptions.radius).toEqual(50);
        });

        it('should set track to visible', function() {
            trackListModel.addTrack(trackCoordinates, 0);
            trackListModel.setVisible(0, true);
            expect(trackListModel.tracks[0].model.trackLine.getVisible()).toEqual(true);
        });

    });
});