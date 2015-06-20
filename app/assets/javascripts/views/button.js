var app = window.app || {};


(function(window, namespace) {

    "use strict";

    /**
     * Button constructor
     * @param $element
     * @param btnText
     * @constructor
     */
    var Button = function($element, btnText) {
        this.$element = $element;
        this.initText = this.setInitText(btnText);
        this.activeState = false;
        namespace.buttonClicked = new ChangeEvent(this);
    };

    /**
     * set the initial button text
     */
    Button.prototype.setInitText = function(btnText) {
        this.$element.text(btnText);
        return btnText;
    };

    /**
     * set the active state of the button
     */
    Button.prototype.setActiveState = function(state) {
        this.activeState = state;
    };

    /**
     * return the button's active state
     * @returns {*}
     */
    Button.prototype.getActiveState = function() {
        return this.activeState;
    };

    /**
     * set button to its initial value
     */
    Button.prototype.resetButton = function() {
        if (this.activeState) {
            this.$element.trigger('click');
        }
    };

    /**
     * set all buttons to their initial value
     * @param deleteBtn
     */
    Button.prototype.resetAllButtons = function(deleteBtn) {
        this.resetButton();
        deleteBtn.resetButton();
    };

    /**
     * trigger the active state-  and the text of the button
     * remove error that no track-points are available
     * @param secBtnText
     */
    Button.prototype.buttonClick = function(secBtnText) {
        var that = this;
        this.$element.click(function() {
            $('.error').remove();
            that.activeState = !!(that.activeState == false);
            $(this).text(function(i, text) {
                namespace.buttonClicked.notify({
                    buttonText: text
                });
                return text === that.initText ? secBtnText : that.initText;
            });
        });
    };


    namespace.Button = Button;

}(window, app));