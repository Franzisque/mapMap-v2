/**
 * button_view_spec.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

describe('ButtonView', function() {

    var buttonView;

    beforeEach(function() {
        buttonView = new app.Button($('.draw-track-btn'), 'Draw Track');
    });

    describe("test buttonView", function() {

        it("it should set the button title", function() {
            expect(buttonView.initText).toEqual('Draw Track');
        });

        it("it should set the active state", function() {
            buttonView.setActiveState(false);
            expect(buttonView.getActiveState()).toBeFalsy();
        });

        it("it should reset the button inscription", function() {
            buttonView.setActiveState(false);
            buttonView.buttonClick('Draw Track');
            buttonView.$element.trigger('click');
            expect(buttonView.getActiveState()).toBeTruthy();
        });

        it("should should trigger the button text", function() {
            buttonView.buttonClick('Stop Drawing');
            buttonView.$element.trigger('click');
            expect(buttonView.initText).toEqual('Draw Track');
        });

        it("it should reset the button inscription", function() {
            buttonView.buttonClick('Stop Drawing');
            buttonView.resetButton();
            expect(buttonView.initText).toEqual('Draw Track');
        });

        it("it should reset the button inscription", function() {
            buttonView.buttonClick('Draw Track');
            buttonView.resetButton();
            expect(buttonView.initText).toEqual('Draw Track');
        });

    });
});