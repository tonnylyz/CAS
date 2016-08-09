$(function () {
    tinymce.init({
        //language: 'zh_CN',
        selector: "#content",
        plugins: [
        "advlist autolink lists link image charmap print preview anchor",
        "searchreplace visualblocks fullscreen",
        "insertdatetime media table contextmenu paste"
        ],
        toolbar: "undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image"
    });

    $("#default>form").submit(function (e) {
        e.preventDefault();
        if ($("#key").val().trim() == "")
            return false;
        $("#default button[type=\"submit\"]").addClass("disabled");
        $("#default button[type=\"submit\"]").attr("disabled", "true");
        $.ajax({
            type: "post",
            url: "ajax.ashx?cat=bulletin&do=search",
            data: { key: $("#key").val() },
            dataType: "json",
            success: function (result) {
                if (result.flag == 0) {
                    if (result.data.length == 0) {
                        Messenger().post({
                            message: "查找到0条结果。",
                            showCloseButton: true
                        });
                    }
                    else {
                        $("#list").slideUp("fast", function () {
                            $("#list").css("display", "none");
                            $("#list").html("");
                            for (var i = 0; i < result.data.length; i++)
                                $("#list").append("<li data-id=\"" + result.data[i].GUID + "\">"
                                                     + "<a onclick=\"bulletinShowNotice(this);\">" + result.data[i].title + "</a>"
                                                + "</li>");
                            $("#list").append("<li><a href=\"Bulletin.aspx\">返回</a></li>");
                            $("#list").slideDown("slow");
                        });
                        Messenger().post({
                            message: "结果已在菜单中显示。",
                            showCloseButton: true
                        });
                    }
                }
                else {
                    Messenger().post({
                        message: "发生系统错误。",
                        type: "error",
                        showCloseButton: true
                    });
                }
                $("#key").val("");
                $("#default button[type=\"submit\"]").removeClass("disabled");
                $("#default button[type=\"submit\"]").removeAttr("disabled");
            }
        });
    });

    $("#submit>form").submit(function (e) {
        e.preventDefault();
        $("#submit button[type=\"submit\"]").addClass("disabled");
        $("#submit button[type=\"submit\"]").attr("disabled", "true");
        $.ajax({
            url: "ajax.ashx?cat=bulletin&do=submit",
            type: "post",
            data: { title: $("#title").val(), content: Base64.encode(tinyMCE.get("content").getContent()) },
            dataType: "json",
            success: function (result) {
                if (result.flag == 0) {
                    Messenger().post({
                        message: "提交成功。",
                        showCloseButton: true
                    });
                    $("#list").prepend("<li data-id=\"" + result.data.GUID + "\"><a onclick=\"bulletinShowNotice(this);\">" + $("#title").val() + "</a></li>");
                    $("#submit>form")[0].reset();
                    tinyMCE.get("content").setContent("");
                    $("#submit").modal("hide");
                }
                else {
                    Messenger().post({
                        message: "提交失败",
                        type: "error",
                        showCloseButton: true
                    });
                }
                $("#submit button[type=\"submit\"]").removeClass("disabled");
                $("#submit button[type=\"submit\"]").removeAttr("disabled");
            }
        });
    });

});


var bulletinCurrentNotice;
function bulletinShowNotice(obj) {
    var uuid = $(obj).parent().data("id");
    if (bulletinCurrentNotice != uuid) {
        bulletinCurrentNotice = uuid;
        var hideid;
        if ($("#default").css("display") == "none")
            hideid = "notice";
        else
            hideid = "default";
        $("#" + hideid).fadeOut("fast", function () {
            $.ajax({
                url: "ajax.ashx?cat=bulletin&do=info&GUID=" + uuid,
                type: "get",
                dataType: "json",
                success: function (result) {
                    if (result.flag == 0) {
                        $("#list li.active").removeClass("active");
                        $("#list li[data-id=\"" + uuid + "\"]").addClass("active");
                        $("#notice").fadeOut("fast", function () {

                            $("#notice").html("<div class=\"page-header\">"
                                             + "<h1>" + result.data.title + " <small>" + result.data.date + "</small></h1>"
                                         + "</div>"
                                         + "<div>" + Base64.decode(result.data.content) + "</div>");
                            $("#notice").fadeIn("fast");
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
        });
    }
}