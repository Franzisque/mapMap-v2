/**
 * global_required.js
 *
 * university:      University of Applied Sciences Salzburg
 * degree course:   MultiMediaTechnology (BSc)
 * usage:           Multimediaprojekt 3 (MMP3)
 * authors:         Stephan Griessner
 *                  Manuel Mitterer
 *                  Franziska Oberhauser
 */

var app = window.app || {};

$(document).ready(function() {

    "use strict";

    /**
     * hamburger menu
     */
    $('#menu-btn').click(function() {
        if ($(window).width() < 992) {
            $('#nav-links').toggleClass('expand');
        }
    });

    /**
     * messages - hover to remove it
     */
    var $messageContainer = $('#nav-message');
    if ($messageContainer.length > 0) {
        $messageContainer.delay(4500).fadeOut(500, function() {
            $(this).remove();
        });
    }

    /**
     * profile nav
     */
    var $profileNav = $('.profile-nav');
    if ($profileNav.length > 0) {
        var $profileList = $('.navbar-profile-nav');
        $profileNav.click(function() {
            if ($profileList.hasClass('profile-active')) {
                $profileList.removeClass('profile-active');
                $('.profile-nav span.fa-caret-up')
                    .removeClass('fa-caret-up')
                    .addClass('fa-caret-down');
            } else {
                $profileList.addClass('profile-active');
                $('.profile-nav span.fa-caret-down')
                    .removeClass('fa-caret-down')
                    .addClass('fa-caret-up');
            }
        });
    }

    /**
     * floating label
     */
    var $floatableInput = $('.floatable input');
    $floatableInput.blur(function() {
        var $this = $(this);

        var $value = $this.val();

        if ($value != "") {
            $this.addClass("not-empty");
        } else {
            $this.removeClass("not-empty");
        }
    });

    if ($floatableInput.length > 0) {
        $floatableInput.each(function() {
            var $that = $(this);
            if ($that.val() != "") {
                $that.addClass("not-empty");
            }
        });
    }

    /**
     *  Get video state of processing and include video when finished
     */
    var $loadingContainer = $('.loading-container');
    if ($loadingContainer.length > 0) {
        var mediaId = $('#media-show').data('id');
        var $parentContainer = $loadingContainer.parent();
        var timer = setInterval(function() {
            $.getJSON("/resources/" + mediaId + "/status.json", function(data) {
                if (data.media.processing === false) {
                    clearInterval(timer);
                    $parentContainer.empty();
                    $parentContainer
                        .append('<video class="video-film" src="' + data.media.video_url + '" controls="controls">' +
                            '</video>');
                }
            }.bind(this));
        }.bind(this), 5000);
    }

    /**
     * hide overlay
     */
    $(document).on('click', '.hide-overlay, .last-button', function() {
        $('#first-time-overlay').fadeOut('fast');
        var d = new Date();
        d.setTime(d.getTime() + (365 * 24 * 60 * 60 * 1000));
        var expires = "expires=" + d.toUTCString();
        document.cookie = 'first-time-overlay=hide; ' + expires;
    });

    /**
     * overlay controls
     */
    $(document).on('click', '.next-button', function(event) {
        $(this).parent('.overlay-step').fadeOut('slow');
        $(this).parent('.overlay-step').next('.overlay-step').fadeIn(500);
    });
    $(document).on('click', '.prev-button', function(event) {
        $(this).parent('.overlay-step').fadeOut('slow');
        $(this).parent('.overlay-step').prev('.overlay-step').fadeIn(500);
    });

    /**
     * overlay hover
     */
    $(document).on('mouseenter', '.highlight-target', function(event) {
        var target = $(this).data('target');
        $('#' + target).addClass('animated-shadow');
    });
    $(document).on('mouseleave', '.highlight-target', function(event) {
        var target = $(this).data('target');
        $('#' + target).removeClass('animated-shadow');
    });

    app.viewHelper = new app.ViewHelper();
});