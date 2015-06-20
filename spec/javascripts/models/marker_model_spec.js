/**
 * marker_model_spec.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

describe('MarkerModel', function() {

    var mapModel;
    var searchMarker;

    beforeEach(function() {
        mapModel = new app.Map('main_map');
        searchMarker = new app.Marker({
            map: mapModel.mapControls,
            draggable: true,
            icon: "/assets/main_marker.png"
        });
        searchMarker.setMarker();
    });

    describe('test marker', function() {

        it('should set marker to place', function() {
            var place = new google.maps.LatLng(43.67048, -116.18620);
            searchMarker.setMarkerToPlace(place);
            expect(searchMarker.marker.getPosition()).toEqual(place);
        });

        it('should set marker visible', function() {
            var place = new google.maps.LatLng(12.420746, 34.305634);
            searchMarker.setMarkerToPlace(place);
            expect(searchMarker.marker.getVisible()).toBeTruthy();
        });

        it('should fix searchMarker', function() {
            searchMarker.triggerMarkerDraggable(false);
            expect(searchMarker.marker.getDraggable()).toBeFalsy();
        });

        it('should create new google maps marker', function() {
            var place = new google.maps.LatLng(8.556015, 40.305917);

            var newMarker = new app.Marker({
                map: mapModel.mapControls,
                draggable: true,
                icon: "/assets/main_marker.png",
                coordinates: place
            });
            newMarker.setMarker();

            expect(typeof searchMarker.marker).toEqual("object");
            expect(newMarker.getDraggable()).toBeTruthy();
        });

        it("should set icon for marker", function() {
            searchMarker.setSearchIcon("/assets/main_marker.png");
            expect(searchMarker.marker.icon.scaledSize.width).toEqual(38);
            expect(searchMarker.marker.icon.scaledSize.height).toEqual(57);
            expect(searchMarker.marker.icon.url).toEqual("/assets/main_marker.png");
        });

    });
});