/**
 * light_box.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

$(document).ready(function() {

    "use strict";

    /**
     * show edit-window if edit-track-button gets clicked
     * @type {*|jQuery|HTMLElement}
     */
    var $editTrackBox = $('#edit-track');
    $('#edit-track-btn').click(function() {
        $editTrackBox.css('display', 'block');
    });

    /**
     * close edit-track-box if the cross icon in the right
     * upper corner gets clicked
     */
    $('#edit-close').click(function() {
        $editTrackBox.css('display', 'none');
    });

    /**
     * light-box for images uploaded to map
     * @constructor
     */
    var LightBox = function() {
        this.imgCounter = 0;
        this.imgThumbClick();
        this.closeLightBox();
        this.displayNexImage();
        this.displayPrevImage();
    };

    /***
     * retrieve the source of the big image and display it
     * in the light-box
     * @param imageThumbs
     */
    LightBox.prototype.displayImage = function(imageThumbs) {
        var imageSrc = imageThumbs.src;
        var largeImgSrc = imageSrc.replace(/\bmedium\b/g, 'large');
        $("#img-light-box").css('display', 'block');
        $("#light-box-img-wrapper").find('img').attr('src', largeImgSrc);
    };

    /**
     * find right image in image-container and retrieve its id.
     * Call the display-image function with right id
     */
    LightBox.prototype.imgThumbClick = function() {
        var imageThumbs = $('.album-image').find('img');
        var that = this;
        imageThumbs.on('click', function() {
            that.imgCounter = imageThumbs.index($(this));
            that.displayImage($(this)[0]);
        });
    };

    /**
     * close the light-box on when the "x" gets clicked
     */
    LightBox.prototype.closeLightBox = function() {
        $('#light-box-close').on('click', function() {
            $('#img-light-box').css('display', 'none');
        });
    };

    /**
     * show the next image and increase counter.
     * If the counter runs out of borders reset it and
     * show the first image again
     */
    LightBox.prototype.displayNexImage = function() {
        $('#right-box-arrow').on('click', function() {
            var imageThumbs = $('.album-image').find('img');
            if (imageThumbs.length - 1 > this.imgCounter) {
                this.imgCounter++;
                this.displayImage(imageThumbs[this.imgCounter]);
            } else {
                this.displayImage(imageThumbs[0]);
                this.imgCounter = 0;
            }
        }.bind(this));
    };

    /**
     * display the previous image and decrease counter. If counter
     * runs out of borders (e. g. gets negative), reset counter and
     * show first image again
     */
    LightBox.prototype.displayPrevImage = function() {
        $('#left-box-arrow').on('click', function() {
            var imageThumbs = $('.album-image').find('img');
            if (this.imgCounter > 0) {
                this.imgCounter--;
                this.displayImage(imageThumbs[this.imgCounter]);
            } else {
                this.displayImage(imageThumbs[imageThumbs.length - 1]);
                this.imgCounter = imageThumbs.length - 1;
            }
        }.bind(this));
    };

    var lightBox = new LightBox();
});