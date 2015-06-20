/**
 * gpx.js
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
    var Gpx = function() {
        this.reader = new FileReader();
        this.parser = new DOMParser();
        /**
         * tracks holds all tracks and for each track an object with the name and its trackpoints
         * which contain latitude and longitude values from the gpx file
         */
        this.tracks = [];
        this.track = [];
        this.errors = [];

        this.chosenTrackId = -1;

        this.gpxDataLoaded = new ChangeEvent(this);
        this.gpxDataLoadFailed = new ChangeEvent(this);
        this.gpxDataParsed = new ChangeEvent(this);
        this.trackIdChanged = new ChangeEvent(this);
    };

    /**
     * read fileextension of the filen
     */
    Gpx.prototype.getFileExtension = function(filename) {
        return (/[.]/.exec(filename)) ? /[^.]+$/.exec(filename) : undefined;
    };

    /**
     * check if the given file is a gpx file -> if true, parse the file
     */
    Gpx.prototype.readGpxFile = function(file) {
        this.tracks = [];
        this.track = [];
        this.errors = [];
        try {
            if (file.files[0].size > 5242880) throw "File too large (max 5mb)";
            var fileExt = this.getFileExtension(file.files[0].name);

            if (fileExt[0] != "gpx" && fileExt[0] != "xml") throw "Wrong File Type";

            this.waitForTextReadComplete(this.reader);
            this.reader.readAsText(file.files[0]);
        } catch (err) {
            this.errors.push(err);
        }
        if (this.errors.length != 0) {
            this.gpxDataLoadFailed.notify({
                errors: this.errors
            });
        }
    };

    /**
     * parse text as xml and return xml object
     */
    Gpx.prototype.parseTextAsXml = function(text) {
        var parsererrorNS = this.parser.parseFromString('INVALID', 'text/xml').getElementsByTagName("parsererror")[0].namespaceURI;
        var xml = this.parser.parseFromString(text, "text/xml");

        if (xml.getElementsByTagNameNS(parsererrorNS, 'parsererror').length > 0) {
            throw 'Error parsing GPX/XML';
        }
        return xml;
    };

    /**
     * read trackname from xml or set it to unnamed
     */
    Gpx.prototype.setTrackName = function(i, track) {
        if (track.getElementsByTagName("name")[0]) {
            this.tracks[i] = {
                'name': track.getElementsByTagName("name")[0].textContent,
                'trackpoints': []
            };
        } else {
            this.tracks[i] = {
                'name': 'unnamed_' + i,
                'trackpoints': []
            };
        }
    };

    /**
     * read trackpoints of xml track and write it to this.tracks
     */
    Gpx.prototype.setTrackPoints = function(i, trkpoints) {
        var pointCount = trkpoints.length;
        var interval = 1;
        var k = 0;

        /**
         * read a maximum of 100 trackpoints per track
         */
        while (pointCount > 100) {
            interval += 1;
            pointCount = trkpoints.length / interval;
        }

        for (var j = 0; j < trkpoints.length; j += interval) {
            this.tracks[i].trackpoints[k] = {
                'A': trkpoints[j].getAttribute("lat"),
                'F': trkpoints[j].getAttribute("lon")
            };
            k++;
        }

        if (j != (trkpoints.length - 1 + interval)) {
            this.tracks[i].trackpoints[k] = {
                'A': trkpoints[trkpoints.length - 1].getAttribute("lat"),
                'F': trkpoints[trkpoints.length - 1].getAttribute("lon")
            };
        }
    };

    /**
     * parse the xml on textReadComplete
     */
    Gpx.prototype.waitForTextReadComplete = function(reader) {
        reader.onloadend = function(event) {
            try {
                var text = event.target.result;
                var xmlinput = this.parseTextAsXml(text);
                var tracklist = xmlinput.getElementsByTagName("trk");

                for (var i = 0; i < tracklist.length; i++) {

                    this.setTrackName(i, tracklist[i]);

                    var trkpoints = tracklist[i].getElementsByTagName("trkpt");

                    this.setTrackPoints(i, trkpoints);
                }

                if (this.tracks.length == 0) {
                    throw "No Tracks found";
                }
            } catch (err) {
                this.errors.push(err);
            }

            if (this.errors.length != 0) {
                this.gpxDataLoadFailed.notify({
                    errors: this.errors
                });
            } else {
                this.gpxDataParsed.notify({
                    gps: this.tracks
                });
            }
        }.bind(this)
    };

    /**
     * select the chosen track
     */
    Gpx.prototype.chooseTrack = function(id) {
        if (id != this.chosenTrackId) {
            this.track = this.tracks[id].trackpoints;
            this.trackIdChanged.notify({
                id: id
            });
            this.gpxDataLoaded.notify({
                gps: this.track
            });
        }
        this.chosenTrackId = id;
    };

    namespace.Gpx = Gpx;

})(window, app);