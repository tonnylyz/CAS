$(function () {
    Messenger.options = {
        extraClasses: "messenger-fixed messenger-on-bottom",
        theme: "flat"
    };
    $(".site-wrapper form").submit(function (e) {
        e.preventDefault();
        if ($("#username").val().trim() == "" || $("#password").val().trim() == "") {
            Messenger().post({
                message: "请将表单填写完整后再试。",
                type: "error",
                showCloseButton: true
            });
            return false;
        }
        $("form button[type=\"submit\"]").addClass("disabled");
        $("form button[type=\"submit\"]").attr("disabled", "true");
        $.ajax({
            url: "ajax.ashx?cat=user&do=login",
            type: "post",
            data: { username: $("#username").val(), password: $("#password").val() },
            dataType: "json",
            success: function (result) {
                if (result.flag == "success") {
                    Messenger().post("登录成功。");
                    window.location.href = "Default.aspx";
                }
                else {
                    Messenger().post({
                        message: "登录失败，请核对您的凭证。",
                        type: "error",
                        showCloseButton: true
                    });
                    $(".site-wrapper form .text-muted").css("opacity", 1);
                }

                $("form button[type=\"submit\"]").removeClass("disabled");
                $("form button[type=\"submit\"]").removeAttr("disabled");
            }
        });
    });
    $("#submit>form").submit(function (e) {
        e.preventDefault();
        if ($("#reg-realname").val().trim() == "" || $("#reg-SN").val().trim() == "" || $("#reg-username").val().trim() == "" || $("#reg-pwd").val().trim() == "" || $("#reg-birthday").val().trim() == "" || $("#reg-qq").val().trim() == "" || $("#reg-phone").val().trim() == "" || $("#reg-mail").val().trim() == "" || $("#reg-intro").val().trim() == "") {
            Messenger().post({
                message: "请将表单填写完整后再试。",
                type: "error",
                showCloseButton: true
            });
            return false;
        }
        $("#submit button[type=\"submit\"]").addClass("disabled");
        $("#submit button[type=\"submit\"]").attr("disabled", "true");
        $.ajax({
            url: "ajax.ashx?cat=user&do=register",
            type: "post",
            data: { realname: $("#reg-realname").val(), SN: $("#reg-SN").val(), username: $("#reg-username").val(), password: $("#reg-pwd").val(), birthday: $("#reg-birthday").val(), QQ: $("#reg-qq").val(), phone: $("#reg-phone").val(), mail: $("#reg-mail").val(), intro: $("#reg-intro").val() },
            dataType: "json",
            success: function (result) {
                if (result.flag == "success") {
                    Messenger().post({
                        message: "注册成功。",
                        showCloseButton: true
                    });
                    $("#submit").modal("hide");
                    window.location.href = "Default.aspx";
                }
                else {
                    Messenger().post({
                        message: "注册失败，请核对信息后重试。",
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
