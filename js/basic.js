//frame control
var frameCurrent;
function frameLoad(frame) {
    if (frameCurrent) {
        if (frameCurrent == frame) {
            $("#" + frameCurrent + "frame").fadeOut("fast");
            frameCurrent = null;
            return;
        } else {
            $("#" + frameCurrent + "frame").fadeOut("fast", function () {
                $("#" + frame + "frame").fadeIn();
            });
            frameCurrent = frame;
        }
        $("#" + frameCurrent + "frame").fadeOut("fast", function () {
            if (frame == "talk") {
                $("#talkframe .popover-content").empty();
                $("#talkframe").fadeIn("fast", function () {
                    talkGet();
                });
            }
            else if (frame == "user") {
                $("#userframe").fadeIn("fast");
            }
        });
    }
    else {
        frameCurrent = frame;
        if (frame == "talk") {
            $("#talkframe .popover-content").empty();
            $("#talkframe").fadeIn("fast", function () {
                talkGet();
            });
        }
        else if (frame == "user") {
            $("#userframe").fadeIn("fast");
        }
    }
}
function frameHide() {
    $("#" + frameCurrent + "frame").fadeOut("fast");
    frameCurrent = null;
}
//user control
function userLogout() {
    $.ajax({
        url: "ajax.ashx?cat=user&do=logout",
        type: "get",
        dataType: "json",
        success: function () {
            Messenger().post({
                message: "注销成功。",
                showCloseButton: true
            });
            window.location.href = "Login.aspx";
        }
    });
}
//talk control
function talkInit() {
    $("#talkframe form").submit(function (e) {
        e.preventDefault();
        $("#talkframe form button[type=\"submit\"]").addClass("disabled");
        $("#talkframe form button[type=\"submit\"]").attr("disabled", "true");
        $.ajax({
            url: "ajax.ashx?cat=talk&do=submit",
            type: "post",
            data: { content: $("#talkframe form input[type=\"text\"]").val() },
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
                $("#talkframe form")[0].reset();
                $("#talkframe form button[type=\"submit\"]").removeClass("disabled");
                $("#talkframe form button[type=\"submit\"]").removeAttr("disabled");
                talkGet();
            }
        });
    });
}
function talkGet() {
    $.ajax({
        type: "get",
        url: "ajax.ashx?cat=talk&do=get",
        dataType: "json",
        success: function (result) {
            if (result.flag == 0) {
                $("#talkframe .popover-content").css("display", "none");
                if (result.data.length != 0)
                    for (var i = 0; i < result.data.length; i++)
                        $("#talkframe .popover-content").append("<div class=\"talk-card\" data-id=\"" + result.data[i].GUID + "\">"
                                                                + "<div>"
                                                                    + "<img onerror=\"this.src='img/icon.login.png'\" src=\"Photo/" + result.data[i].UUID + ".jpg\" />"
                                                                + "</div>"
                                                                + "<div>"
                                                                    + "<p>" + result.data[i].name + " <small class=\"text-muted\">@" + result.data[i].username + "</small></p>"
                                                                    + "<blockquote>"
                                                                        + "<p>" + result.data[i].content + "</p>"
                                                                    + "</blockquote>"
                                                                    + "<p class=\"text-right\"><small class=\"text-muted pull-left\">" + result.data[i].date + "</small>"
                                                                        + "<span onclick=\"talkSet(this, 0)\" class=\"glyphicon glyphicon-ok\"></span> <span onclick=\"talkSet(this, 1)\" class=\" glyphicon glyphicon-thumbs-up\"></span></p>"
                                                                + "</div>"
                                                                + "<div class=\"clearfix\"></div>"
                                                               + "</div>");
                else
                    $("#talkframe .popover-content").html("暂无未读消息");
                $("#talkframe .popover-content").css("opacity", "0");
                $("#talkframe .popover-content").slideDown("slow", function () {
                    $("#talkframe .popover-content").animate({"opacity": "1"}, "slow");
                });
            }
            else {
                $("#talkframe .popover-content").html("暂无未读消息");
                Messenger().post({
                    message: "发生系统错误。",
                    type: "error",
                    showCloseButton: true
                });
            }
        }
    });
}
function talkSet(obj, flag) {
    var card = $(obj).parent().parent().parent();
    card.animate({ "opacity": "0" }, function () {
        card.slideUp();
        card.remove();
        if ($("#talkframe .popover-content").html() == "")
            $("#talkframe .popover-content").html("暂无未读消息");
    });
    $.ajax({
        type: "get",
        url: "ajax.ashx?cat=talk&do="+(flag == 0 ? "read" : "praise")+"&TUID=" + card.data("id"),
    });
}

$(function () {
    Messenger.options = {
        extraClasses: "messenger-fixed messenger-on-bottom",
        theme: "flat"
    };
    talkInit();
    //pageScript(window.location.pathname.split("/").reverse()[0].replace(".aspx", "").toLowerCase());
});

