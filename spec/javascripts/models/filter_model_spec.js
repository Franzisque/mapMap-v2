/**
 * filter_model_spec.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

describe('FilterModel', function() {

    var FilterModel, form, mapModel;

    beforeEach(function() {
        form = "<form><input id='tag-box' value='skiing'></form>";
        mapModel = new app.Map('main_map');

        FilterModel = new app.Filter($(form), mapModel.mapControls);
    });

    describe('constructor', function() {

        it("should set the tagList to value of tag-box input", function() {
            expect(FilterModel.tagList).toEqual(['skiing']);
        });

        it("should set the tracks and visibleTracks to be empty array", function() {
            expect(FilterModel.tracks).toEqual([]);
            expect(FilterModel.visibleTracks).toEqual([]);
        });

        it("should set the minRadius to 10000", function() {
            expect(FilterModel.minRadius).toEqual(10000);
        });

    });

    describe('updateTagPriority', function() {

        it("should update the tags priority", function() {
            FilterModel.tagCounter['skiing'] = 5;
            FilterModel.updateTagPriority(FilterModel.tagList);

            expect(FilterModel.tagCounter['skiing']).toEqual(6);
        });

    });
});