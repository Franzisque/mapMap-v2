/**
 * tagbox.js
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
     * @constructor
     */
    var TagBox = function($tagbox, data, opts, includeSelf) {
        this.opts = opts || {};
        this.data = data;
        this.items = [];
        this.$tagbox = $tagbox;
        this.tagbox = 0;
        this.includeSelf = includeSelf == false ? false : true;

        this.initialize();
    };

    /**
     * load the list of tags
     */
    TagBox.prototype.initialize = function() {
        $.getJSON('/' + this.data + '.json', this.initializeTagBox.bind(this));
    };

    /**
     * initialize the tagbox when taglist is loaded
     */
    TagBox.prototype.initializeTagBox = function(response) {
        this.items = [];

        for (var i = 0; i < response.data.length; i++) {
            if (this.includeSelf || !response.data[i].current) {
                this.items.push({
                    'value': response.data[i].name,
                    'allow': response.data[i].allow
                });
            }
        }
        this.opts.items = this.items;
        this.tagbox = $(this.$tagbox).tagbox(this.opts);
    };

    /**
     * update the taglist
     */
    TagBox.prototype.update = function() {
        this.tagbox.parents('.form-horizontal').find('.tagbox-token a').each(function() {
            $(this).trigger('click');
        });
    };

    namespace.TagBox = TagBox;

})(window, app);