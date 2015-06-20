/**
 * map_style.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

var app = window.app || {};

(function(namespace) {

    "use strict";

    // lightgrey: #B8B8B8
    // darkgrey: #373737

    namespace.mapStyle = [{
        "featureType": "water",
        "elementType": "all",
        "stylers": [{
            "hue": "#76aee3"
        }, {
            "saturation": 38
        }, {
            "lightness": -11
        }, {
            "visibility": "on"
        }]
    }, {
        "featureType": "road",
        "elementType": "all",
        "stylers": [{
            "saturation": -100
        }, {
            "lightness": 45
        }, {
            "visibility": "on"
        }]
    }, {
        "featureType": "poi.park",
        "elementType": "all",
        "stylers": [{
            "hue": "#c6e3a4"
        }, {
            "saturation": 17
        }, {
            "lightness": -2
        }, {
            "visibility": "on"
        }]
    }, {
        "featureType": "administrative.land_parcel",
        "elementType": "all",
        "stylers": [{
            "hue": "#5f5855"
        }, {
            "saturation": 6
        }, {
            "lightness": -31
        }, {
            "visibility": "on"
        }]
    }, {
        "featureType": "water",
        "elementType": "all",
        "stylers": []
    }]

})(app);