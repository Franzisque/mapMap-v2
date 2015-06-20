/**
 * filter_components.js
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
     * initialize tagbox if it is present
     */
    if ($('#tag-box').length) {
        var tagboxModel = new app.TagBox('#tag-box', 'tags', {
            allowNew: true
        });
    }
    if ($('#tag-box-user').length) {
        var userTagboxModel = new app.TagBox('#tag-box-user', 'users', {
            className: 'single',
            maxItems: 1,
            tokenFormat: '<a href="/user/{{value}}">{{value}}</a>'
        });
    }
    if ($('#tag-box-new-user').length) {
        var userTagboxModel2 = new app.TagBox('#tag-box-new-user', 'users', {
            className: 'single',
            maxItems: 1,
            autoShow: true,
            rowFormat: '<div class="show-{{allow}}">{{value}}</div>'
        }, false);
        $('#tag-box-new-user').change(function(event) {
            if ($(this).val() != '') {
                var loc = '/messages/' + $(this).val();
                $(location).attr('href', loc);
            }
        });
    }

    /**
     * Collapse Filters
     */
    $('h2.collapsebar').off('click').on('click', function(event) {
        if ($(this).hasClass('uncollapsed')) {
            $(this).removeClass('uncollapsed');
            $(this).next('.form-horizontal').slideUp('fast');
            $(this).addClass('collapsed');
            $(this).prev('.reset-form').addClass('hidden');
        } else {
            $(this).removeClass('collapsed');
            $(this).next('.form-horizontal').slideDown('fast');
            $(this).addClass('uncollapsed');
            $(this).prev('.reset-form').removeClass('hidden');
        }
    });

    /**
     * Clear Filter
     */
    $('.reset-form').on('click', function(event) {
        $('.filter-bar').find('.form-horizontal')[0].reset();
        tagboxModel.update();
        userTagboxModel.update();
    });

    /**
     * filter toggle
     */
    var $filterToggleBtn = $('#filter-toggle');
    var $toggleBar = $('#toggle-bar');
    $filterToggleBtn.click(function() {
        $filterToggleBtn.toggleClass('active');
        $toggleBar.toggleClass('active');
    });

    if ($filterToggleBtn.length > 0 && $(window).width() > 480) {
        $filterToggleBtn.addClass('active');
        $toggleBar.addClass('active');
    }

    $(document).on('mouseenter', '.search-location', function(event) {
        $('#location-search input').addClass('highlight');
    });
    $(document).on('mouseleave', '.search-location', function(event) {
        $('#location-search input').removeClass('highlight');
    });
    $(document).on('click', '.search-location', function(event) {
        $('#location-search input').focus();
    });
});