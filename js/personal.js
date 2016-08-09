var cropData, jcrop_api;

$("#file").fileinput({
    language: "zh",
    showUpload: false,
    showPreview: false,
    showUploadedThumbs: false,
    uploadUrl: "ajax.ashx?cat=user&do=avatar"
});
$("#file").on("fileuploaded", function (event, data, previewId, index) {
    var result = data.response;
    if (result.flag == 0) {
        Messenger().post({
            message: "上传完成，请完成裁切。",
            showCloseButton: true
        });
        $("#avatar>form").fadeOut("fast", function () {
            $("#avatar .col-md-8 img").attr("src", "Photo/c_" + result.data.ipath);
            $("#avatar .col-md-4 img").attr("src", "Photo/c_" + result.data.ipath);

            $("#avatar>div").fadeIn();
            var boundx, boundy;
            $("#avatar .col-md-8 img").Jcrop({
                onChange: function (c) {
                    if (parseInt(c.w) > 0) {
                        var rx = $("#avatar .col-md-4 .preview-container").width() / c.w;
                        var ry = $("#avatar .col-md-4 .preview-container").height() / c.h;
                        cropData = c;
                        $("#avatar .col-md-4").fadeIn("fast");
                        $("#avatar .col-md-4 img").css({
                            width: Math.round(rx * boundx) + "px",
                            height: Math.round(ry * boundy) + "px",
                            marginLeft: "-" + Math.round(rx * c.x) + "px",
                            marginTop: "-" + Math.round(ry * c.y) + "px"
                        });
                    }
                },
                onSelect: function (c) {
                    if (parseInt(c.w) > 0) {
                        $("#avatar .col-md-4").fadeIn("fast");
                    }
                },
                aspectRatio: 1
            }, function () {
                boundx = this.getBounds()[0];
                boundy = this.getBounds()[1];
                jcrop_api = this;
            });
        });
    }
    else {
        Messenger().post({
            message: "系统错误。",
            type: "error",
            showCloseButton: true
        });
    }
});
$(function () {
    $("#birthday").datetimepicker({
        useCurrent: false
    });

    $.ajax({
        url: "ajax.ashx?cat=user&do=info",
        type: "get",
        dataType: "json",
        success: function (result) {
            if (result.flag == 0) {
                $("#birthday").val(result.data.birthday);
                $("#qq").val(result.data.QQ);
                $("#phone").val(result.data.phone);
                $("#mail").val(result.data.mail);
                $("#intro").val(result.data.intro);
            }
            else {
                Messenger().post({
                    message: "发生系统错误。",
                    type: "error",
                    showCloseButton: true
                });
            }
        }
    });



    $("#pwd>form").submit(function (e) {
        e.preventDefault();
        $("#pwd button[type=\"submit\"]").addClass("disabled");
        $("#pwd button[type=\"submit\"]").attr("disabled", "true");
        if ($("#passwordn").val() == $("#passwordr").val()) {
            $.ajax({
                url: "ajax.ashx?cat=user&do=info",
                type: "post",
                data: { password: $("#password").val(), passwordn: $("#passwordn").val() },
                dataType: "json",
                success: function (result) {
                    if (result.flag == 0) {
                        Messenger().post({
                            message: "提交成功。",
                            showCloseButton: true
                        });
                        $("#pwd>form")[0].reset();
                    }
                    else {
                        Messenger().post({
                            message: "提交失败",
                            type: "error",
                            showCloseButton: true
                        });
                    }
                    $("#pwd button[type=\"submit\"]").removeClass("disabled");
                    $("#pwd button[type=\"submit\"]").removeAttr("disabled");
                }
            });
        }
        else {
            Messenger().post({
                message: "两次键入不一致。",
                type: "error",
                showCloseButton: true
            });
        }
    });

    $("#avatar>div form").submit(function (e) {
        e.preventDefault();
        $("#avatar>div button[type=\"submit\"]").addClass("disabled");
        $("#avatar>div button[type=\"submit\"]").attr("disabled", "true");
        $.ajax({
            url: "ajax.ashx?cat=user&do=crop",
            type: "post",
            data: { x: cropData.x, y: cropData.y, w: cropData.w, h: cropData.h },
            dataType: "json",
            success: function (result) {
                if (result.flag == 0) {
                    Messenger().post({
                        message: "提交成功。",
                        showCloseButton: true
                    });
                    jcrop_api.destroy();
                    $("#avatar .col-md-8 img").removeAttr("style");
                    $(".navbar-right>ul:nth-child(2) img").attr("src", "Photo/" + $(".navbar-right>ul:nth-child(2) img").data("id") + ".jpg?t=" + Math.random());
                    $("#avatar>div").fadeOut("fast", function () {
                        $("#avatar>form").fadeIn();
                    });
                    $("#file").fileinput("clear");
                    $("#file").fileinput("reset");
                }
                else {
                    Messenger().post({
                        message: "提交失败",
                        type: "error",
                        showCloseButton: true
                    });
                }
                $("#avatar>div button[type=\"submit\"]").removeClass("disabled");
                $("#avatar>div button[type=\"submit\"]").removeAttr("disabled");
            }
        });
    });

    $("#info>form").submit(function (e) {
        e.preventDefault();
        $("#info button[type=\"submit\"]").addClass("disabled");
        $("#info button[type=\"submit\"]").attr("disabled", "true");
        $.ajax({
            url: "ajax.ashx?cat=user&do=info",
            type: "post",
            data: { birthday: $("#birthday").val(), qq: $("#qq").val(), phone: $("#phone").val(), mail: $("#mail").val() },
            dataType: "json",
            success: function (result) {
                if (result.flag == 0) {
                    Messenger().post("提交成功。");
                }
                else {
                    Messenger().post({
                        message: "发生系统错误。",
                        type: "error",
                        showCloseButton: true
                    });
                }
                $("#info button[type=\"submit\"]").removeClass("disabled");
                $("#info button[type=\"submit\"]").removeAttr("disabled");
            }
        });
    });
});