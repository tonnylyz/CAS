
$("#file").fileinput({
    language: "zh",
    showUpload: false,
    showPreview: false,
    showUploadedThumbs: false,
    uploadUrl: "ajax.ashx?cat=gallery&do=submit",
    uploadExtraData: function () {
        return {
            title: $("#title").val()
        };
    }
});
$("#file").on("fileloaded", function (event, file, previewId, index, reader) {
    console.log(file.name.replace(".jpg", "").replace(".jpeg", ""));
    $("#title").val(file.name.replace(".jpg", "").replace(".jpeg", ""));
});
$("#file").on("fileerror", function (event, data) {
    Messenger().post({
        message: "发生系统错误。",
        type: "error",
        showCloseButton: true
    });
});
$("#file").on("fileuploaded", function (event, data, previewId, index) {
    var result = data.response;
    if (result.flag == 0) {
        Messenger().post("提交成功。");
        $("#gallery>ul").prepend("<li class=\"mix col-sm-3\" data-name=\"" + $("#title").val() + "\" style=\"display: inline-block;\">"
                                    + "<a class=\"thumbnail swipebox\" href=\"Photo/" + result.data.GUID + ".jpg\" title=\"" + $("#title").val() + "\">"
                                       + "<img src=\"Photo/" + result.data.GUID + "_thumb.jpg\">"
                                       + "<div class=\"caption\">"
                                          + "<h4>" + $("#title").val() + "</h4>"
                                       + "</div>"
                                    + "</a>"
                                + "</li>"
            );
    }
    else {
        Messenger().post({
            message: "发生系统错误。",
            type: "error",
            showCloseButton: true
        });
    }
    $("#submit").modal("hide");
    $("#title").val("");
    $("#file").fileinput("reset");
    //setTimeout("window.location.reload();", 3000);

});

$(function () {
    $(".swipebox").swipebox();
    $("#gallery ul.row").mixItUp({
        animation:
        {
            enable: true,
            effects: "fade",
            duration: 600,
            easing: "ease",
            perspectiveDistance: "3000px",
            perspectiveOrigin: "50% 50%",
            queue: true,
            queueLimit: 1,
            animateChangeLayout: false,
            animateResizeContainer: true,
            animateResizeTargets: false,
            staggerSequence: null,
            reverseOut: false,
        },
        Selector: {
            target: ".mix"
        }
    });
});
