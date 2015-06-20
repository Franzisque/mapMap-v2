/**
 * filter_controller.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

var app = window.app || {};

(function(window, namespace) {

    "use strict";

    /**
     * FilterController with filterModel and filterView
     * @param filterModel
     * @param filterView
     * @constructor
     */
    var FilterController = function(filterModel, filterView) {

        this._model = filterModel;
        this._view = filterView;

        this._view.inputChanged.register(function(sender, data) {
            this._model.updateResult();
        }.bind(this));

        this._view.clickResult.register(function(sender, data) {
            this._model.updateMapCenter(data);
        }.bind(this));

        this._model.resourceLoaded.register(function(sender, data) {
            this._view.printResult(data);
        }.bind(this));
    };

    /**
     * call model to filter visible tracks
     */
    FilterController.prototype.filterTracks = function() {
        this._model.filterVisibleTracks();
    };

    namespace.FilterController = FilterController;

})(window, app);