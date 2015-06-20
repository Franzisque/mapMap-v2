/**
 * filter_view.js
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
     *
     * @param filterModel
     * @param $filterForm
     * @param $filterResults
     * @constructor
     */
    var FilterView = function(filterModel, $filterForm, $filterResults) {

        this.$filterForm = $filterForm;
        this.$filterResults = $filterResults;

        this.inputChanged = new ChangeEvent(this);
        this.hoverResultIn = new ChangeEvent(this);
        this.hoverResultOut = new ChangeEvent(this);
        this.clickResult = new ChangeEvent(this);

        this.initialize();
    };

    /**
     *  initialize filterview and set eventhandlers for formchange and reset
     */
    FilterView.prototype.initialize = function() {
        this.$filterForm.off('change').change(function(event) {
            this.update();
            event.preventDefault();
        }.bind(this));
        this.$filterForm.off('reset').on('reset', function(event) {
            this.update();
        }.bind(this));
    };

    /**
     *  update the results of the filter
     */
    FilterView.prototype.update = function() {
        var that = this;
        this.$filterResults.fadeOut('fast', function() {
            that.inputChanged.notify();
        });
    };

    /**
     *  convert the results of the filter to html
     */
    FilterView.prototype.getHTML = function(result) {
        var resultHtml = '<div class="result-container no-result"><h5 class="no-tracks">No Tracks found</h5><p class="clear-filter">Clear Filter</p><p>or</p><p class="search-location">search for Location</p></div>';
        if (result.length > 0) {
            resultHtml = '';
            for (var i = 0; i < result.length; i++) {
                var count = i + 1;
                resultHtml += '<div class="result-container" id="resource_' + i + '" data-trackid="' + i + '">';
                resultHtml += '<h5><a href="' + result[i].url + '">' + count + '. ' + result[i].title + '</a></h5>';
                resultHtml += '<div class="media-icon ' + result[i].type.toLowerCase() + '-icon"></div>';
                resultHtml += '<div class="media-title"><img src="' + result[i].thumburl + '"></div>'; //<%= render :partial => index_partial_for( result.medium ), locals: { resource: result } %>
                resultHtml += '<div class="result-info">';
                resultHtml += '<p><i class="fa fa-user "></i><a href="' + result[i].user.url + '">' + result[i].user.username + '</a></p>';
                resultHtml += '<p><i class="fa fa-clock-o "></i>' + result[i].created_at + '</p>';
                resultHtml += '<p><i class="fa fa-eye "></i>' + result[i].views + ' views</p>';
                resultHtml += '</div>';
                resultHtml += '</div>';
            }
        }

        return resultHtml;
    };

    /**
     *  print the resultHTML to the correct DOM Element
     */
    FilterView.prototype.printResult = function(data) {
        var result = data.resources;

        var resultHtml = this.getHTML(result);

        this.$filterResults.html(resultHtml);
        this.$filterResults.fadeIn('fast');

        this.addEventListeners();
    };

    /**
     *  add eventlisteners for hover and click events on results
     */
    FilterView.prototype.addEventListeners = function() {
        var that = this;
        $('.clear-filter').on('click', function(event) {
            $('.reset-form').trigger('click');
        });

        $('.result-container').off('hover').hover(function(event) {
            var id = $(this).data('trackid');
            if (id != undefined) that.hoverResultIn.notify({
                id: id
            });
        }, function(event) {
            var id = $(this).data('trackid');
            if (id != undefined) that.hoverResultOut.notify({
                id: id
            });
        });
        $('.result-container').off('click').click(function(event) {
            var target = $(event.target);

            if (target.is('a')) {
                return true;
            } else {
                var id = $(this).data('trackid');
                if (id != undefined) that.clickResult.notify({
                    id: id
                });
            }
        });
    };

    FilterView.prototype.highlightResource = function(data) {
        $('#filter-toggle:not(.active)').addClass('active');
        $('#toggle-bar:not(.active)').addClass('active');
        this.$filterResults.find('#resource_' + data.id).addClass('hover');

        var targetOffset = $('#resource_' + data.id).offset().top - ($('#toggle-bar').height() / 2) + $('#toggle-bar').scrollTop();

        $('#toggle-bar').stop().animate({
            'scrollTop': targetOffset
        }, 500, 'swing');
    };

    FilterView.prototype.deHighlightResource = function(data) {
        this.$filterResults.find('#resource_' + data.id).removeClass('hover');
    };

    namespace.FilterView = FilterView;

})(window, app);