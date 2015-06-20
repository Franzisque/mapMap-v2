/**
 * tagbox_model_spec.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

describe('TagBoxModel', function() {

    var TagBoxModel;

    beforeEach(function() {
        TagBoxModel = new app.TagBox('test', 'tags');
    });

    describe('initialize', function() {

        it("should set data", function() {
            expect(TagBoxModel.data).toEqual('tags');
        });

        it("should set selfincluded", function() {
            expect(TagBoxModel.includeSelf).toEqual(true);
        });

        it("should set items to empty array", function() {
            expect(TagBoxModel.items).toEqual([]);
        });
    });

    describe('load items', function() {
        it("should load tags into items", function() {
            var tags = {
                data: [{
                    name: "rookie"
                }, {
                    name: "advanced"
                }, {
                    name: "pro"
                }]
            };
            TagBoxModel.initializeTagBox(tags);

            expect(TagBoxModel.items.length).toEqual(3);
            expect(TagBoxModel.items[0].value).toEqual('rookie');
        });
    });
});