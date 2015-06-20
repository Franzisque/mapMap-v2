/**
 * about_page_scrolling.js
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
     * scroll to the right info-content if the according link gets clicked
     * @param $emitter
     * @param $element
     */
    function scrollPageToElement($emitter, $element) {
        $emitter.on('click', function() {
            $('html, body').animate({
                scrollTop: $element.offset().top - 60 // height of head-menu
            }, 700);
        });
    }
    scrollPageToElement($('.create-account'), $("#create-step"));
    scrollPageToElement($('.select-resource'), $("#select-step"));
    scrollPageToElement($('.specify-details'), $("#detail-step"));
    scrollPageToElement($('.add-track'), $("#track-step"));
});