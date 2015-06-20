/**
 * gpx_view_spec.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

describe('GpxView', function() {

    var gpxView, gpxModel;

    beforeEach(function() {
        form = $('#gpx');
        gpxModel = new app.Gpx();
        gpxView = new app.GpxView(gpxModel, form, 'gpx-upload');
    });

    describe("contructor", function() {

        it("should set dom elements for inputfield", function() {
            var inputField = document.getElementById('gpx-upload');
            expect(gpxView.inputFile).toEqual(inputField);
        });

        it("should set eventhandlers for change", function() {
            var ev = $._data($(gpxView.inputFile)[0], 'events');
            expect(ev.change.length).toEqual(1);
        });
    });

    describe("methods", function() {
        it("should show trackchooser", function() {
            gpxView.showTrackChooser([]);
            expect($('#track_chooser').length).toEqual(1);
        });
    });
});