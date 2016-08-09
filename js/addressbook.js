$.ajax({
    type: "get",
    url: "ajax.ashx?cat=user&do=list",
    dataType: "json",
    success: function (result) {
        if (result.flag == 0) {
            $("#addressbook>.row").fadeOut("fast", function () {
                for (var i = 0; i < result.data.length; i++)
                    if (result.data[i].username != "")
                    $("#addressbook>.row").append("<li class=\"media\">"
                                                    + "<a data-uuid=\"" + result.data[i].UUID + "\" onclick=\"addressBookShowInfo(this)\">"
                                                        + "<div class=\"media-left\">"
                                                            + "<img onerror=\"this.src='img/icon.login.png'\" src=\"Photo/" + result.data[i].UUID + ".jpg\" />"
                                                        + "</div>"
                                                        + "<div class=\"media-body\">"
                                                            + "<h4 class=\"media-heading\">" + result.data[i].name + " <small>@" + result.data[i].username + "</small></h4>"
                                                            + "<blockquote>"
                                                                + "<p>" + result.data[i].intro + "</p>"
                                                            + "</blockquote>"
                                                        + "</div>"
                                                    + "</a>"
                                                + "</li>");
                $("#addressbook>.row").css("opacity", "0");
                $("#addressbook>.row").slideDown("slow", function () {
                    $("#addressbook>.row").animate({ "opacity": "1" }, "slow");
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

//addressbook control
function addressBookShowInfo(obj) {
    var UUID = $(obj).data("uuid");
    $.ajax({
        type: "get",
        url: "ajax.ashx?cat=user&do=info&UUID=" + UUID,
        dataType: "json",
        success: function (result) {
            if (result.flag == 0) {
                $("#info .modal-header h4").html(result.data.name);
                $("#mail").val(result.data.mail);
                $("#username").val(result.data.username);
                $("#birth").val(result.data.birthday.replace(" 0:00:00", ""));
                $("#phone").val(result.data.phone);
                $("#qq").val(result.data.QQ);
                $("#info").modal("show");
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
}