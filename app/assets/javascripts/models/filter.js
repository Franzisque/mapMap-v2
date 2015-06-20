/**
 * filter.js
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
    var Filter = function($form, map) {
        this.$form = $form;
        this.map = map;
        this.tracks = [];
        this.visibleTracks = [];
        this.tagList = [];
        this.tagCounter = {};
        this.minRadius = 10000;

        this.resourceLoaded = new ChangeEvent(this);

        if (this.getCookie("filter-tags-counter")) this.tagCounter = JSON.parse(this.getCookie("filter-tags-counter"));
        this.updateResult();
    };

    /**
     * filters tracks in this.tracks, by the bounds of the current viewport
     */
    Filter.prototype.filterVisibleTracks = function() {
        this.visibleTracks = [];

        var max = 0;
        if (this.tracks.length <= 50) max = this.tracks.length;
        else max = 50;

        for (var i = 0; i < max; i++) {
            if (this.tracks[i].tracks.length > 0 && this.map.getBounds() && this.isInRadius(this.tracks[i].tracks[0])) {
                this.visibleTracks.push(this.tracks[i]);
            }
        }
        this.resourceLoaded.notify({
            resources: this.visibleTracks
        });
    };

    /**
     * updates the center of the viewport to the center of the shown track
     */
    Filter.prototype.updateMapCenter = function(locationData) {
        var trackCoords = [];
        var bounds = new google.maps.LatLngBounds();

        for (var i = 0; i < this.visibleTracks[locationData.id].tracks.length; i++) {
            trackCoords[i] = new google.maps.LatLng(this.visibleTracks[locationData.id].tracks[i].A, this.visibleTracks[locationData.id].tracks[i].F)
        }

        for (var j = 0; j < trackCoords.length; j++) {
            bounds.extend(trackCoords[j]);
        }

        // extend bounds for zoom and corrected center purposes
        var ne = new google.maps.LatLng(bounds.getNorthEast().lat(), bounds.getNorthEast().lng() + 0.02);
        bounds.extend(ne);

        var center = bounds.getCenter();
        this.map.panTo(center);
    };

    /**
     * checks if given location is in radius of the viewport center
     */
    Filter.prototype.isInRadius = function(location) {
        var mapCenter = this.map.getBounds().getCenter();
        var mapNE = this.map.getBounds().getNorthEast();
        var loc_position = new google.maps.LatLng(location.A, location.F);
        var viewPortRadius = google.maps.geometry.spherical.computeDistanceBetween(mapCenter, mapNE);

        if (viewPortRadius < this.minRadius) {
            var distance = google.maps.geometry.spherical.computeDistanceBetween(mapCenter, loc_position);

            if (distance <= this.minRadius) return true;
            else return false;
        } else {
            return this.map.getBounds().contains(loc_position);
        }
    };

    /**
     * sortfunction to sort an object by priorities of tags
     */
    Filter.prototype.sortByTags = function() {
        var that = this;

        this.tracks.sort(function(a, b) {
            var x = 0;
            var y = 0;

            for (var i = 0; i < a.tags.length; i++) {
                if (that.tagCounter[a.tags[i].name] > 0) x += that.tagCounter[a.tags[i].name];
            }
            for (var j = 0; j < b.tags.length; j++) {
                if (that.tagCounter[b.tags[j].name] > 0) y += that.tagCounter[b.tags[j].name];
            }

            return ((x > y) ? -1 : ((x < y) ? 1 : 0));
        });
    };

    /**
     * writes cookie
     */
    Filter.prototype.setCookie = function(cname, cvalue, exdays) {
        var d = new Date();
        d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
        var expires = "expires=" + d.toUTCString();
        document.cookie = cname + "=" + cvalue + "; " + expires;
    };

    /**
     * receives cookie data for given name
     */
    Filter.prototype.getCookie = function(cname) {
        var name = cname + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') c = c.substring(1);
            if (c.indexOf(name) == 0) return c.substring(name.length, c.length);
        }
        return "";
    };

    /**
     * update the tag priorities
     */
    Filter.prototype.updateTagPriority = function(tags) {
        for (var i = 0; i < tags.length; i++) {
            if (this.tagCounter[tags[i]] != undefined) this.tagCounter[tags[i]] += 1;
            else this.tagCounter[tags[i]] = 1;
        }
    };

    /**
     * load new resources with given filters
     */
    Filter.prototype.updateResult = function() {
        var formData = this.$form.serialize();

        var tags = this.$form.find("#tag-box").val().split(',');

        if (tags[0] != "" && !tags.equals(this.tagList)) {
            this.updateTagPriority(tags);
        }

        this.tagList = tags;

        this.setCookie("filter-tags-counter", JSON.stringify(this.tagCounter), 30);

        this.sendRequest(formData);
    };

    /**
     * asynchronous GET Request to receive the new tracks
     */
    Filter.prototype.sendRequest = function(formData) {
        var that = this;
        $.ajax({
            type: "GET",
            dataType: "json",
            url: "/resources",
            data: formData,
            success: function(data) {
                that.tracks = data.media;
                that.sortByTags();
                that.filterVisibleTracks();
            }
        });
    };

    namespace.Filter = Filter;

})(window, app);