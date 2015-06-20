/**
 * filter_view_spec.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

describe('FilterView', function() {

    var filterView, filterModel, mapModel;

    beforeEach(function() {
        form = "<form><input id='tag-box' value='skiing'></form>";
        mapModel = new app.Map('main_map');
        filterModel = new app.Filter($(form), mapModel.mapControls);
        filterView = new app.FilterView(filterModel, $(form), $('#filter-results'));
    });

    describe("contructor", function() {

        it("should set dom elements for results", function() {
            var resultsDOM = $('#filter-results');
            expect(filterView.$filterResults).toEqual(resultsDOM);
        });

        it("should set eventhandlers for change", function() {
            var ev = $._data(filterView.$filterForm[0], 'events');
            expect(ev.change.length).toEqual(1);
        });

        it("should set eventhandlers for reset", function() {
            var ev = $._data(filterView.$filterForm[0], 'events');
            expect(ev.reset.length).toEqual(1);
        });
    });

    describe("methods", function() {

        it("should set eventhandlers for hover to result", function() {
            filterView.addEventListeners();
            var ev = $._data($('.result-container')[0], 'events');
            expect(ev.mouseover.length).toEqual(1);
            expect(ev.mouseout.length).toEqual(1);
        });

        it("should set eventhandlers for click to result", function() {
            filterView.addEventListeners();
            var ev = $._data($('.result-container')[0], 'events');
            expect(ev.click.length).toEqual(1);
        });

        it("should highlight resource", function() {
            var data = {
                id: 0
            };
            filterView.highlightResource(data);
            expect($('#resource_0').hasClass('hover')).toEqual(true);
        });

        it("should dehighlight resource", function() {
            var data = {
                id: 0
            };
            filterView.deHighlightResource(data);
            expect($('#resource_0').hasClass('hover')).toEqual(false);
        });
    });

});