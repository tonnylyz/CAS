$.ajax({
    type: "get",
    url: "ajax.ashx?cat=talk&do=list",
    dataType: "json",
    success: function (result) {
        if (result.flag == 0) {
            $("#talk>div").fadeOut("fast", function () {
                $("#talk>div").css("display", "none");
                if (result.data.length == 0)
                    $("#talk>div").append("<p>暂无</p>");
                else
                    for (var i = 0; i < result.data.length; i++)
                        $("#talk>div").append("<div class=\"talk-card\">"
                                                + "<div>"
                                                    + "<img onerror=\"this.src='img/icon.login.png'\" src=\"Photo/" + result.data[i].UUID + ".jpg\" />"
                                                + "</div>"
                                                + "<div>"
                                                    + "<p>" + result.data[i].name + " <small class=\"text-muted\">@" + result.data[i].username + "</small></p>"
                                                    + "<blockquote>"
                                                        + "<p>" + result.data[i].content + "</p>"
                                                    + "</blockquote>"
                                                    + "<p class=\"text-right\"><small class=\"text-muted pull-left\">" + result.data[i].date + "</small></p>"
                                                + "</div>"
                                                + "<div class=\"clearfix\"></div>"
                                                + "</div>");
                $("#talk>div").css("opacity", "0");
                $("#talk>div").slideDown("slow", function () {
                    $("#talk>div").animate({ "opacity": "1" }, "slow");
                });
            });
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
