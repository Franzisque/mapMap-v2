/**
 * map_model_spec.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

describe('MapModel', function() {

    var mapModel;
    var mapControls;

    beforeEach(function() {
        mapModel = new app.Map('main_map');
        mapControls = mapModel.mapControls;
    });

    describe('test mapModel', function() {

        it("should handle object with lat and lng", function() {
            var testCoords = {
                latitude: 38.907192,
                longitude: -77.000000
            };
            mapModel.handleInitialLocation(testCoords);
            expect(mapControls.getCenter().lat()).toEqual(38.907192);
            expect(mapControls.getCenter().lng()).toEqual(-77.000000);
        });
    });
});