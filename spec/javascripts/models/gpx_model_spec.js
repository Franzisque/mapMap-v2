/**
 * gpx_model_spec.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

describe('GpxModel', function() {

    var GpxModel, xml, parsed;

    beforeEach(function() {
        xml = '<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?><gpx version="1.0" creator="ExpertGPS 1.2 - http://www.topografix.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.topografix.com/GPX/1/0" xmlns:topografix="http://www.topografix.com/GPX/Private/TopoGrafix/0/2" xsi:schemaLocation="http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd http://www.topografix.com/GPX/Private/TopoGrafix/0/2 http://www.topografix.com/GPX/Private/TopoGrafix/0/2/topografix.xsd">';

        xml += '<trk><name>CLEMENTINE</name>';
        xml += '<desc>Clementine Loop</desc>';
        xml += '<number>1</number>';
        xml += '<topografix:color>ff0000</topografix:color>';
        xml += '<trkseg>';
        xml += '<trkpt lat="38.919839863" lon="-121.020112049">';
        xml += '<ele>265.447754</ele>';
        xml += '<time>2003-02-05T18:19:20Z</time>';
        xml += '<sym>Waypoint</sym>';
        xml += '</trkpt>';
        xml += '<trkpt lat="38.919796947" lon="-121.020240795">';
        xml += '<ele>264.967041</ele>';
        xml += '<time>2003-02-05T18:19:20Z</time>';
        xml += '<sym>Waypoint</sym>';
        xml += '</trkpt></trkseg></trk></gpx>';

        Gpx = new app.Gpx();
        parsed = Gpx.parseTextAsXml(xml);
    });

    describe('constructor', function() {

        it("should set tracks, track and errors to empty array", function() {
            expect(Gpx.tracks).toEqual([]);
            expect(Gpx.track).toEqual([]);
            expect(Gpx.errors).toEqual([]);
        });

    });

    describe('Parse xml', function() {
        it("should parse xml correct", function() {
            var track = parsed.getElementsByTagName("trk")[0];
            Gpx.setTrackName(0, track);

            expect(Gpx.tracks[0].name).toEqual('CLEMENTINE');
        });

        it("should set trackpoints from xml", function() {
            var track = parsed.getElementsByTagName("trk")[0];
            Gpx.setTrackName(0, track);

            var trkpoints = track.getElementsByTagName("trkpt");
            Gpx.setTrackPoints(0, trkpoints);

            expect(Gpx.tracks[0].trackpoints[0].A).toEqual("38.919839863");
        });
    });

    describe('select track', function() {
        it("should set track to be the chosen track", function() {
            var track = parsed.getElementsByTagName("trk")[0];
            Gpx.setTrackName(0, track);

            var trkpoints = track.getElementsByTagName("trkpt");
            Gpx.setTrackPoints(0, trkpoints);

            Gpx.chooseTrack(0);

            expect(Gpx.track).toEqual(Gpx.tracks[0].trackpoints);
        });
    });
});
