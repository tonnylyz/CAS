$(function () {
    Messenger.options = {
        extraClasses: 'messenger-fixed messenger-on-bottom',
        theme: 'flat'
    }
    $('#login-form').submit(function (e) {
        e.preventDefault();
        $('#loginsub').addClass('disabled');
        $('#loginsub').attr('disabled', "true");
        $.ajax({
            url: 'ajax.ashx?action=login',
            type: 'post',
            data: { 'username': $('#username').val(), 'password': $('#password').val() },
            dataType: "json",
            success: function (result) {
                if (result.flag == 'success') {
                    Messenger().post(result.data.info);
                    window.location.href = 'Default.aspx';
                }
                else {
                    Messenger().post({
                        message: result.data.info,
                        type: 'error',
                        showCloseButton: true
                    });
                }
                $('#loginsub').removeClass('disabled');
                $('#loginsub').removeAttr('disabled');
            }
        });
    });
})