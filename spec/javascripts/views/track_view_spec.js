/**
 * track_view_spec.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

describe('TrackView', function() {

    var mapModel;
    var trackModel;
    var trackView;
    var trackCoordinates;
    var gMapsCoordinates = [];

    beforeEach(function() {
        mapModel = new app.Map('main_map');
        trackModel = new app.Track(mapModel.mapControls);
        trackView = new app.TrackView(trackModel, app.Button);

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

    describe("test trackView", function() {

        it("it should set marker to position", function() {
            trackView.setSearchMarkerPosition(gMapsCoordinates[0]);
            expect(trackView.searchMarkerPos.lat()).toEqual(43.676189);
        });

        it("it should reset delete button", function() {
            trackModel.setTrackPoints(trackCoordinates, true);
            trackView.resetDeleteButton(true);
            expect(trackView.deleteCircleBtn.getActiveState()).toBeFalsy();
        });

        it("it should set the initial state of the delete-button", function() {
            var drawTrackBtn = new app.Button($('.draw-track-btn'), 'Stop Deleting');
            trackView.initDeleteBtn(drawTrackBtn);
            expect(drawTrackBtn.$element.text()).toEqual("Delete Track-Point");
        });

        it("it should label the draw-track button", function() {
            trackView.drawTrackBtn = new app.Button($('.draw-track-btn'), 'Draw Track');
            trackView.labelButton();
            expect(trackView.drawTrackBtn.$element.text()).toEqual('Draw Track');
        });

    });
});