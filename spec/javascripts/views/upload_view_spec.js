/**
 * upload_view_spec.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

describe('UploadView', function() {

    var uploadView, uploadInput;

    beforeEach(function() {
        uploadInput = $('#file-upload');
        uploadView = new app.UploadView('video', uploadInput);
    });

    afterEach(function() {
        $('.errors').remove();
        $('.uploaded-files').remove();
        $('.progress').remove();
    });

    describe("contructor", function() {

        it("should set uploadform to dom element", function() {
            expect(uploadView.$uploadForm.attr('id')).toEqual('upload');
        });

        it("should set nextpage to form action", function() {
            expect(uploadView.nextPage).toEqual('/');
        });

        it("should set types to correct extensions", function() {
            var types = /(\.|\/)(mov|mpeg|mpe?g?4|avi)$/i;
            expect(uploadView.types).toEqual(types);
        });

        it("should set eventhandlers for click", function() {
            var ev = $._data(uploadView.$submitBtn[0], 'events');
            expect(ev.click.length).toEqual(1);
        });

        it("should insert DOM elements for files and errors", function() {
            expect($('.errors').length).toEqual(1);
            expect($('.uploaded-files').length).toEqual(1);
            expect($('.progress').length).toEqual(1);
        });
    });

    describe("methods", function() {
        it("should set progressbar to correct value", function() {
            uploadView.fileuploadProgress({}, {
                loaded: 50,
                total: 100
            });
            var totalWidth = $('.progress').width();
            expect($('.progress .bar').width()).toEqual(Math.round(totalWidth / 2));
        });

        it("should set errors to correct values", function() {
            uploadView.fileuploadFail({}, {
                jqXHR: {
                    responseJSON: ["Testerror"]
                }
            });
            expect(uploadView.$submitBtn[0].disabled).toEqual(false);
            expect($('#error-0').html()).toEqual("Error: Testerror");
        });
    });
});