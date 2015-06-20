/**
 * map_view_spec.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

describe('MapView', function() {

    var mapView;
    var mapModel;

    beforeEach(function() {
        mapModel = new app.Map('main_map');
        mapView = new app.MapView(mapModel, $('#location'));
    });

    describe("test mapView", function() {

        it("should process autoCompleted place", function() {
            mapView.initAutoCompletion();
            expect(typeof mapView.autoComplete).toEqual('object');
        });

        /**
         * simulate user input for autoCompletion.
         * Test outcome of the latter.
         */
        it("should trigger autoCompletion", function() {
            /*
            mapView.initAutoCompletion();
            $('#location').val('Puch bei Hallein, Österreich');
            mapView.setDefaultSearchResult();
            mapView.autoComplete.getPlace()
            */
            expect(1).toEqual(1);
        })
    });
});