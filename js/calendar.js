$(function () {
    $("#start").datetimepicker({
        useCurrent: true
    });
    $("#end").datetimepicker({
        useCurrent: false
    });
    $("#start").on("dp.change", function (e) {
        $('#end').data("DateTimePicker").minDate(e.date);
    });
    $("#end").on("dp.change", function (e) {
        $('#start').data("DateTimePicker").maxDate(e.date);
    });
    $("#last").bootstrapSwitch();
    $("#last").on("switchChange.bootstrapSwitch", function () {
        $("#submit .form-horizontal").children().eq(2).toggle("fast");
        $('#end').val("");
        if ($('#start').data("DateTimePicker").maxDate())
            $('#start').data("DateTimePicker").maxDate(false);
    });
    $.ajax({
        url: "ajax.ashx?cat=calendar&do=get",
        type: "get",
        dataType: "json",
        success: function (result) {
            if (result.flag == 0) {
                for (var i = 0; i < result.data.length; i++) {
                    var start = result.data[i].startstr.split("-");
                    result.data[i].start = new Date(start[0], start[1] - 1, start[2]);
                    if (result.data[i].endstr) {
                        var end = result.data[i].endstr.split("-");
                        result.data[i].end = new Date(end[0], end[1] - 1, end[2]);
                    }
                }
                $("#calendar>div").fullCalendar({ editable: false, events: result.data, displayEventTime: false });
            }
        }
    });
    $("#submit>form").submit(function (e) {
        e.preventDefault();
        $("#submit button[type=\"submit\"]").addClass("disabled");
        $("#submit button[type=\"submit\"]").attr("disabled", "true");
        if ($("#last").is(":checked") == false) {
            $("#end").val($("#start").val());
        }
        $.ajax({
            url: "ajax.ashx?cat=calendar&do=submit",
            type: "post",
            data: { info: $("#info").val(), start: $("#start").val(), end: $("#end").val() },
            dataType: "json",
            success: function (result) {
                if (result.flag == 0) {
                    Messenger().post({
                        message: "提交成功。",
                        showCloseButton: true
                    });
                    $("#calendar>div").fullCalendar("addEventSource", [{ title: $("#info").val(), start: $("#start").data("DateTimePicker").date(), end: $("#end").data("DateTimePicker").date() }]);
                    $("#submit>form")[0].reset();
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
                //setTimeout("window.location.reload();", 3000);
            }
        });
    });
});