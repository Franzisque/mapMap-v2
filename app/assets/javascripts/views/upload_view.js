/**
 * upload_view.js
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
     *
     * @constructor
     */
    var UploadView = function(uploadtype, $inputField, nextpage) {
        this.$uploadForm = $inputField.closest('form');
        this.$submitBtn = $('#file_upload_btn');
        this.nextPage = nextpage || this.$uploadForm.attr('action');
        this.uploadType = uploadtype;
        this.types = /(\.|\/)(gif|jpe?g|png|mov|mpeg|mpeg4|avi)$/i;
        this.allData = {};
        this.addData = 0;
        this.errors = [];
        this.errorIndex = [];

        this.initialize();
    };

    /**
     * add trackdata to the form, so it gets sent through the fileupload request
     */
    UploadView.prototype.addDataToForm = function() {
        if (this.addData != 0) {
            var that = this;
            if (this.addData.resource.distance != undefined) this.$uploadForm.append('<input type="hidden" name="resource[distance]" value="' + this.addData.resource.distance + '">');

            $.each(that.addData.resource.tracks_attributes, function(i, data) {
                that.$uploadForm.append('<input type="hidden" name="resource[tracks_attributes][][latitude]" value="' + data.latitude + '">');
                that.$uploadForm.append('<input type="hidden" name="resource[tracks_attributes][][longitude]" value="' + data.longitude + '">');
            });
        }
    };

    /**
     * send an async request to the database
     */
    UploadView.prototype.sendRequest = function(data) {
        data.event.preventDefault();

        $.ajax({
            type: 'POST',
            url: data.url,
            data: data.formData,
            success: function(result, status) {
                if (status == "success") {
                    $(location).attr('href', data.redirectUrl);
                }
            }
        });
    };

    /**
     * submit the form or show error if something is wrong
     */
    UploadView.prototype.submit = function(event, addData) {
        var that = this;
        this.addData = addData || 0;
        if ($('#edit-track').length > 0) $('#edit-track').fadeOut('fast');

        var title = $('#resource_title').val();

        if (this.allData !== undefined && this.allData.files !== undefined && title !== '') {
            this.addDataToForm();

            this.allData.submit();

            this.$submitBtn.attr('disabled', true);
            $('.progress-state').html('uploading...');
            $('.progress').fadeIn('fast');
            event.preventDefault();
        } else if (title != '') {
            var id = $('#media-edit').data('id');
            var data = {
                event: event,
                formData: this.$uploadForm.serialize(),
                url: "/resources/" + id,
                redirectUrl: "/resources/" + id
            };

            if (this.addData != 0) data.formData += '&' + $.param(this.addData);

            this.sendRequest(data);
        }
    };

    /**
     * initialize the fileupload with its html
     */
    UploadView.prototype.initialize = function() {
        var that = this;
        var html = '<div class="errors"></div><div class="uploaded-files"></div><div class="progress"><div class="progress-bar bar" style="width: 0%"></div><div class="progress-state">uploading...</div></div>';
        if (this.uploadType == "video") {
            this.types = /(\.|\/)(mov|mpeg|mpe?g?4|avi)$/i;
        } else if (this.uploadType == "image") {
            this.types = /(\.|\/)(gif|jpe?g|png)$/i;
        }

        $(html).insertAfter(this.$uploadForm.find('input[type="file"]').parent());

        this.$submitBtn.off('click').click(function(event) {
            this.submit(event);
        }.bind(this));

        /**
         * Initialize the jQuery File Upload widget:
         */
        this.$uploadForm.fileupload({
            singleFileUploads: false,
            dataType: 'json',
            progressInterval: 10,
            add: that.fileuploadAdd.bind(that),
            progressall: that.fileuploadProgress.bind(that),
            done: that.fileuploadDone.bind(that),
            fail: that.fileuploadFail.bind(that)
        });
    };

    /**
     * eventhandler for fileuploadResetProgress
     */
    UploadView.prototype.fileuploadResetProgress = function() {
        $('div.errors').html('');
        $('.progress').fadeOut('fast');
        $('.progress .bar').css('width', '0%');
        $('div.uploaded-files').html('');
    };

    /**
     * create preview for images through the HTML5 FileReader
     */
    UploadView.prototype.fileuploadPreview = function(i, file) {
        if (this.types.test(file.type) || this.types.test(file.name)) {
            var tmp = {
                file: file,
                id: i
            }
            this.allData.context = $(tmpl("template-upload", tmp));
            $('div.uploaded-files').append(this.allData.context);

            if (this.uploadType == "image") {
                var reader = new FileReader();
                reader.onload = function(e) {
                    var image = new Image();
                    image.onload = function() {
                        $('#file-' + i).append('<canvas id="canvas-' + i + '"></canvas>');
                        var canvas = document.getElementById("canvas-" + i);
                        var ctx = canvas.getContext("2d");
                        canvas.width = 50;
                        canvas.height = 50 * (image.height / image.width);
                        ctx.drawImage(image, 0, 0, canvas.width, canvas.height);
                    }
                    image.src = e.target.result;
                }
                reader.readAsDataURL(file);
            } else {
                $('#file-' + i).css({
                    'background-image': 'url("/assets/film-icon.png")',
                    'height': '44px'
                });
            }

        } else {
            this.errors.push({
                html: "<span class='error' id='error-" + i + "'>" + file.name + ": Format not supported.</span>",
                id: i
            });
            this.errorIndex.push({
                id: i,
                name: file.name
            });
        }
    };

    /**
     * eventhandler for fileuploadAdd
     */
    UploadView.prototype.fileuploadAdd = function(e, data) {
        this.errors = [];
        this.errorIndex = [];
        this.allData = data;

        this.fileuploadResetProgress();

        if (this.allData.files.length > 10) this.errors.push({
            html: "<span class='error' id='error-" + 0 + "'>Too many Files. (max. 10)</span>",
            id: 0
        });
        else {
            var that = this;
            $.each(this.allData['files'], function(i, file) {
                this.fileuploadPreview(i, file);
            }.bind(this));
        }

        for (var i = 0; i < this.errorIndex.length; i++) {
            this.allData.files.splice(findIndexByKeyValue(this.allData.files, "name", this.errorIndex[i].name), 1);
        }

        for (var i = 0; i < this.errors.length; i++) {
            $('div.errors').append(this.errors[i].html);
            var id = this.errors[i].id;
        }
    };

    /**
     * eventhandler for fileuploadProgress
     */
    UploadView.prototype.fileuploadProgress = function(e, data) {
        var progress = parseInt(data.loaded / data.total * 100, 10);
        if (progress >= 99) {
            $('.progress-state').fadeOut('fast', function() {
                $(this).html('processing...').fadeIn('fast');
            });
        }
        $('.progress .bar').css('width', progress + '%');
    };

    /**
     * eventhandler for fileuploadDone
     */
    UploadView.prototype.fileuploadDone = function(e, data) {
        window.location = this.nextPage;
    };

    /**
     * eventhandler for fileuploadFail
     */
    UploadView.prototype.fileuploadFail = function(e, data) {
        this.$submitBtn.attr('disabled', false);
        $('.progress-state').fadeOut('fast');
        if (data.jqXHR && data.jqXHR.responseJSON) {
            for (var i = 0; i < data.jqXHR.responseJSON.length; i++) {
                var error = data.jqXHR.responseJSON[i];
                $('div.errors').append('<span class="error" id="error-' + i + '">Error: ' + error + '</span>');
            }
        } else {
            $('div.errors').append('<span class="error">Unknown Error. Please try again.</span>');
        }
    };

    namespace.UploadView = UploadView;

})(window, app);