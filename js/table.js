
function tableCheck(obj) {
    var regExp = new RegExp($(obj).data("regexp"));
    if (!regExp.test($(obj).val()))
        $(obj).parent().addClass("has-error");
    else
        $(obj).parent().removeClass("has-error");
}

$("#table>form").submit(function (e) {
    e.preventDefault();
    if ($("#table>form input").val().trim() == "" || $("#table>form input").hasClass("has-error")) {
        Messenger().post({
            message: "请检查您的输入。",
            type: "error",
            showCloseButton: true
        });
        return false;
    }
    $("#table>form button[type=\"submit\"]").addClass("disabled");
    $("#table>form button[type=\"submit\"]").attr("disabled", "true");
    $.ajax({
        url: "ajax.ashx?cat=table&do=submit",
        type: "post",
        data: $(this).serializeArray(),
        dataType: "json",
        success: function (result) {
            if (result.flag == 0) {
                Messenger().post("提交成功。");
            }
            else {
                Messenger().post({
                    message: "提交失败，请检查您的输入。",
                    type: "error",
                    showCloseButton: true
                });
            }

            $("#table>form button[type=\"submit\"]").removeClass("disabled");
            $("#table>form button[type=\"submit\"]").removeAttr("disabled");
        }
    });
});