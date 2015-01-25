var frameCurrent;
function frameLoad(frame) {
    if (frameCurrent) {
        $('#' + frameCurrent + 'frame').fadeOut('fast', function () {
            switch (frame) {
                case 'talk':
                    $('#talkframe').fadeIn('fast');
                    frameCurrent = 'talk';
                    talkGet();
                    break;
                case 'user':
                    $('#userframe').fadeIn('fast');
                    frameCurrent = 'user';
                    break;
            }
        });
    }
    else {
        switch (frame) {
            case 'talk':
                $('#talkframe').fadeIn('fast');
                talkGet();
                frameCurrent = 'talk';
                break;
            case 'user':
                $('#userframe').fadeIn('fast');
                frameCurrent = 'user';
                break;
        }
    }
}
function frameHide() {
    $('#' + frameCurrent + 'frame').fadeOut('fast');
}

function userLogout() {
    $.ajax({
        url: 'ajax.ashx?action=logout',
        type: 'get',
        dataType: "json",
        success: function (result) {
            Messenger().post({
                message: result.data.info,
                showCloseButton: true
            });
            window.location.href = 'Login.aspx';
        }
    });
}
function talkInit() {
    $('#talkform').submit(function (e) {
        e.preventDefault();
        $('#talksub').addClass('disabled');
        $('#talksub').attr('disabled', "true");
        $.ajax({
            url: 'ajax.ashx?action=talksub',
            type: 'post',
            data: { talksubct: $('#talksubct').val() },
            dataType: 'json',
            success: function (result) {
                if (result.flag == 'success') {
                    Messenger().post('提交成功。');
                }
                else if (result.flag == 'info') {
                    Messenger().post({
                        message: "字数限制在255字内。",
                        type: 'info',
                        showCloseButton: true
                    });
                }
                else {
                    Messenger().post({
                        message: "发生系统错误。",
                        type: 'error',
                        showCloseButton: true
                    });
                }
                $('#talksubct').val('');
                $('#talksub').removeClass('disabled');
                $('#talksub').removeAttr('disabled');
            }
        });
    });
}
var talkFilled = false;
var talkCount = 0;
function talkGet() {
    if (!talkFilled) {
        $("#talkcontent").html("<div style='margin-left:90px'><img src='img/loading.gif'/></div>");
        $.ajax({
            type: "get",
            url: "ajax.ashx?action=gettalk",
            dataType: 'json',
            success: function (result) {
                $("#talkcontent").fadeOut("fast", function () {
                    $("#talkcontent").css("display", "none");
                    $("#talkcontent").html("");
                    talkCount = result.data.length;
                    if (result.data.length != 0) {
                        for (var i = 0; i < result.data.length; i++)
                            $("#talkcontent").append('<div class=\"talkcard\" data-id=\"' + result.data[i].GUID + '\"><div class=\"talkcardhead\"><img id=\"userhead\" src=\"Photo/' + result.data[i].UUID + '.jpg\" height=\"40px\" width=\"40px\"></div><div class=\"talkcardinfo\"><p class=\"talkoptitle\">' + result.data[i].name + '@' + result.data[i].username + '</p><p class=\"talkoptitlerd\"><a onclick=\"talkRead(this)\">×</a> | <a onclick=\"talkGood(this)\">赞</a></p></div><div class=\"talkcardtime\">' + result.data[i].date + '</div><div class=\"talkcardcontent\">' + result.data[i].cont + '</div></div>');
                    }
                    else {
                        $("#talkcontent").html("暂无未读消息");
                    }
                    $("#talkcontent").css("opacity", "0");
                    $("#talkcontent").slideDown('slow', function () {
                        $("#talkcontent").animate({ "opacity": "1" }, "slow");
                    });
                });
            }
        });
        talkFilled = true;
    }
    else {
        $.ajax({
            type: "get",
            url: "ajax.ashx?action=gettalk",
            dataType: 'json',
            success: function (result) {
                $("#talkcontent").html("");
                talkCount = result.data.length;
                if (result.data.length != 0) {
                    for (var i = 0; i < result.data.length; i++)
                        $("#talkcontent").append('<div class=\"talkcard\" data-id=\"' + result.data[i].GUID + '\"><div class=\"talkcardhead\"><img id=\"userhead\" src=\"Photo/' + result.data[i].UUID + '.jpg\" height=\"40px\" width=\"40px\"></div><div class=\"talkcardinfo\"><p class=\"talkoptitle\">' + result.data[i].name + '@' + result.data[i].username + '</p><p class=\"talkoptitlerd\"><a onclick=\"talkRead(this)\">×</a> | <a onclick=\"talkGood(this)\">赞</a></p></div><div class=\"talkcardtime\">' + result.data[i].date + '</div><div class=\"talkcardcontent\">' + result.data[i].cont + '</div></div>');
                }
                else {
                    $("#talkcontent").html("暂无未读消息");
                }
            }
        });
    }
}

function talkRead(obj) {
    var card = $(obj).parent().parent().parent();
    card.animate({ "opacity": "0" }, function () {
        card.slideUp();
        talkCount--;
        if (talkCount == 0)
            $("#talkcontent").html("暂无未读消息");
    });
    $.ajax({
        type: "get",
        url: "ajax.ashx?action=talkread&TUID=" + card.data('id'),
    });
}

function talkGood(obj) {
    var card = $(obj).parent().parent().parent();
    card.animate({ "opacity": "0" }, function () {
        card.slideUp();
        talkCount--;
        if (talkCount == 0)
            $("#talkcontent").html("暂无未读消息");
    });
    $.ajax({
        type: "get",
        url: "ajax.ashx?action=talkgood&TUID=" + card.data('id'),
    });
}

function pageScript(page) {
    switch (page) {
        case "addressbook":
            $.ajax({
                type: "get",
                url: "ajax.ashx?action=getaddressbook",
                dataType: 'json',
                success: function (result) {
                    if (result.flag == 'success') {
                        $("#cardcont").fadeOut("fast", function () {
                            for (var i = 0; i < result.data.length; i++)
                                $("#cardcont").append('<div class=\"col-sm-4 cardspan\"><div class=\"infocard\"><a data-uuid=\"' + result.data[i].UUID + '\" onclick=\"addressBookShowInfo(this)\"><img src=\"Photo/' + result.data[i].UUID + '.jpg\" /><h4>' + result.data[i].name + ' <small>@' + result.data[i].username + '</small></h4></a></div></div>');
                            $("#cardcont").css("opacity", "0");
                            $("#cardcont").slideDown("slow", function () {
                                $("#cardcont").animate({ "opacity": "1" }, "slow");
                            });
                        });
                    }
                }
            });
            break;
        case "bulletin":
            loadScript("js/tinymce/tinymce.min.js", function () {
                tinymce.init({
                    language: 'zh_CN',
                    selector: "#iocontent",
                    theme: "modern",
                    plugins: [
		                "advlist autolink lists link image charmap print preview hr anchor pagebreak",
		                "searchreplace wordcount visualblocks visualchars code fullscreen",
		                "insertdatetime media nonbreaking save table contextmenu directionality",
		                "emoticons paste textcolor"
                    ],
                    toolbar1: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | print preview media | forecolor backcolor",
                    image_advtab: true,
                });
            });
            $(function () {
                $('#searchformid').submit(function (e) {
                    e.preventDefault();
                    $('#searchsub').addClass('disabled');
                    $('#searchsub').attr('disabled', "true");
                    $.ajax({
                        type: 'get',
                        url: 'ajax.ashx?action=getbulletin&searchkey=' + $('#searchkey').val(),
                        dataType: 'json',
                        success: function (result) {
                            console.log(result.data.length);
                            if (result.flag == 'info') {
                                Messenger().post({
                                    message: '请输入关键字。',
                                    showCloseButton: true
                                });
                            }
                            else if (result.flag == 'success') {
                                if (result.data.length == 0) {
                                    Messenger().post({
                                        message: '查找到0条结果。',
                                        showCloseButton: true
                                    });
                                }
                                else {
                                    $('#bultlist').slideUp("fast", function () {

                                        $('#bultlist').css("display", "none");
                                        $("#bultlist").html('');
                                        for (var i = 0; i < result.data.length; i++) {
                                            var item = '<li data-id=\"' + result.data[i].GUID + '\"><a onclick=\"bulletinShowNotice(this);\">' + result.data[i].title + '</a></li>';
                                            $("#bultlist").append(item);
                                        }
                                        $("#bultlist").append('<li><a href=\"Bulletin.aspx\">返回</a></li>');
                                        $("#bultlist").slideDown("slow");
                                    });
                                    Messenger().post({
                                        message: '结果已在菜单中显示。',
                                        showCloseButton: true
                                    });
                                }
                            }
                            $('#searchkey').val('');
                            $('#searchsub').removeClass('disabled');
                            $('#searchsub').removeAttr('disabled');
                        },
                    });
                });
                $("#ioformsub").submit(function (e) {
                    e.preventDefault();
                    $("#iosub").addClass("disabled");
                    $("#iosub").attr("disabled", "true");
                    var base = new Base64();
                    $.ajax({
                        url: "ajax.ashx?action=noticesub",
                        type: "post",
                        data: { iocont: base.encode(tinyMCE.get('iocontent').getContent()), iotitle: $("#iotitle").val() },
                        dataType: 'json',
                        success: function (result) {
                            if (result.flag == 'success') {
                                Messenger().post({
                                    message: "提交成功。",
                                    showCloseButton: true
                                });
                                $("#ioformsub")[0].reset();
                                $("#iosub").removeClass("disabled");
                                $("#iosub").removeAttr("disabled");
                                $('#iomodal').modal('hide');
                                window.location.reload();
                            }
                            else {
                                $("#iosub").removeClass("disabled");
                                $("#iosub").removeAttr("disabled");
                                Messenger().post({
                                    message: "提交失败",
                                    type: "error",
                                    showCloseButton: true
                                });
                            }
                        }
                    });
                });
            });
            break;
        case "calendar":
            loadScript("js/bootstrap-datetimepicker.min.js", function () {
                loadCSS("css/bootstrap-datetimepicker.min.css", function () { });
                $('#iosta').datetimepicker({
                    autoclose: true,
                    format: 'yyyy-mm-dd',
                    minView: 4
                });
                $('#ioend').datetimepicker({
                    autoclose: true,
                    format: 'yyyy-mm-dd',
                    minView: 4
                });
            });
            loadScript("js/bootstrap-switch.min.js", function () {
                loadCSS("css/bootstrap-switch.min.css", function () { });
                $("[name='iocheck']").bootstrapSwitch();
                $("[name='iocheck']").on('switchChange.bootstrapSwitch', function () {
                    $("#sendb").toggle("fast");
                });
            });

            loadScript("js/fullcalendar.js", function () {
                loadCSS("css/fullcalendar.css", function () { });
                $.ajax({
                    url: "ajax.ashx?action=getcalendar",
                    type: "get",
                    dataType: 'json',
                    success: function (result) {
                        if (result.flag == 'success') {
                            for (var i = 0; i < result.data.length; i++)
                            {
                                var start = result.data[i].startstr.split('-');
                                result.data[i].start = new Date(start[0], start[1] - 1, start[2]);
                                if (result.data[i].endstr) {
                                    var end = result.data[i].endstr.split('-');
                                    result.data[i].end = new Date(end[0], end[1] - 1, end[2]);
                                }
                            }
                            console.log(result.data[40]);
                            $('#calendar').fullCalendar({ editable: false, events: result.data });
                        }
                    },
                    error: function (result) { console.log(result) }
                });
            });
            $(function () {
                $("#ioformsub").submit(function (e) {
                    e.preventDefault();
                    $("#iosub").addClass("disabled");
                    $("#iosub").attr("disabled", "true");
                    if ($("#iocheck").is(':checked') == false) {
                        $("#ioend").val($("#iosta").val());
                    }
                    $.ajax({
                        url: "ajax.ashx?action=calendarsub",
                        type: "post",
                        data: { ioinfo: $("#ioinfo").val(), iosta: $("#iosta").val(), ioend: $("#ioend").val() },
                        dataType: 'json',
                        success: function (result) {
                            console.log = (result.flag);
                            if (result.flag == 'success') {
                                Messenger().post({
                                    message: "提交成功。",
                                    showCloseButton: true
                                });
                                $("#ioformsub")[0].reset();
                                $('#iomodal').modal('hide');
                                window.location.reload();
                            }
                            else {
                                Messenger().post({
                                    message: "提交失败",
                                    type: "error",
                                    showCloseButton: true
                                });
                            }
                            $("#iosub").removeClass("disabled");
                            $("#iosub").removeAttr("disabled");
                        }
                    });
                });
            });

            break;
        case "gallery":
            loadScript("js/jquery.swipebox.min.js", function () {
                loadCSS("css/swipebox.css", function () { });
                $(".swipebox").swipebox();
            });
            loadScript("js/jquery.mixitup.min.js", function () {
                $('#galleryul').mixItUp({
                    animation:
					{
					    enable: true,
					    effects: 'fade',
					    duration: 600,
					    easing: 'ease',
					    perspectiveDistance: '3000px',
					    perspectiveOrigin: '50% 50%',
					    queue: true,
					    queueLimit: 1,
					    animateChangeLayout: false,
					    animateResizeContainer: true,
					    animateResizeTargets: false,
					    staggerSequence: null,
					    reverseOut: false,
					},
                    Selector: {
                        target: '.mix'
                    }
                });
            });
            $(function () {
                $("#ioformsub").submit(function (e) {
                    e.preventDefault();
                    $("#iosub").addClass("disabled");
                    $("#iosub").attr("disabled", "true");
                    loadScript("js/ajaxfileupload.js", function () {
                        $.ajaxFileUpload({
                            url: "ajax.ashx?action=photosub&title=" + $("#title").val(),
                            fileElementId: 'iofile',
                            type: "post",
                            success: function (data) {
                                var result = JSON.parse(data.body.textContent);
                                if (result.data == 'success') {
                                    Messenger().post({
                                        message: "上传完成。",
                                        showCloseButton: true
                                    });
                                }
                                else {
                                    Messenger().post({
                                        message: "系统错误。",
                                        type: "error",
                                        showCloseButton: true
                                    });
                                }
                                $("#ioformsub")[0].reset();
                                $('#iomodal').modal('hide');
                                $("#iosub").removeClass("disabled");
                                $("#iosub").removeAttr("disabled");
                                window.location.reload();
                            }
                        });
                    });
                });
            });

            break;
        case "talk":
            $.ajax({
                type: "get",
                url: "ajax.ashx?action=gethistalk",
                dataType: "json",
                success: function (result) {
                    if (result.flag == 'success') {
                        $("#histalkct").fadeOut("fast", function () {
                            $("#histalkct").css("display", "none");
                            if (result.data.length == 0)
                                $("#histalkct").append("<p>暂无</p>");
                            else
                                for (var i = 0; i < result.data.length; i++)
                                    $("#histalkct").append('<div><img style=\"float:left;margin:5px\" src=\"Photo/' + result.data[i].UUID + '.jpg\" height=\"40px\" width=\"40px\"/><h4 style=\"float:left;padding-top:10px\">' + result.data[i].name + '：</h4><p style=\"clear:both\">' + result.data[i].cont + '</p><p style=\"text-align:right;color:#ccc;\">' + result.data[i].date + '</p></div><hr>');
                            $("#histalkct").css("opacity", "0");
                            $("#histalkct").slideDown('slow', function () {
                                $("#histalkct").animate({ "opacity": "1" }, "slow");
                            });
                        });
                    }

                }
            });
            break;
        case "homework":
            $("#ioformsub").submit(function (e) {
                e.preventDefault();
                $("#iosub").addClass("disabled");
                $("#iosub").attr("disabled", "true");
                var cont = $("#iocont").val().split("\n");
                var rcont = cont.length;
                for (var i = 0; i < cont.length; i++) {
                    rcont = rcont + "," + cont[i];
                }
                $.ajax({
                    url: "ajax.ashx?action=homeworksub",
                    type: "post",
                    data: { iocont: rcont },
                    dataType: 'json',
                    success: function (result) {
                        if (result.flag == 'success') {
                            Messenger().post({
                                message: "提交成功。",
                                showCloseButton: true
                            });
                            $("#ioformsub")[0].reset();
                            $('#iomodal').modal('hide');
                            window.location.reload();
                        }
                        else {
                            Messenger().post({
                                message: "提交失败",
                                type: "error",
                                showCloseButton: true
                            });
                        }
                        $("#iosub").removeClass("disabled");
                        $("#iosub").removeAttr("disabled");
                    }
                });
            });

            break;
        case "personal":
            $(function () {
                $.ajax({
                    url: 'ajax.ashx?action=getinfo',
                    type: 'get',
                    dataType: 'json',
                    success: function (result) {
                        if (result.flag == 'success') {
                            $("#birthday").val(result.data.birthday);
                            $("#QQ").val(result.data.QQ);
                            $("#phone").val(result.data.phone);
                            $("#mail").val(result.data.mail)
                        }
                    }
                });

                $('#passwordform').submit(function (e) {
                    e.preventDefault();
                    $('#passwordsub').addClass('disabled');
                    $('#passwordsub').attr('disabled', "true");
                    if ($("#passwordn").val() == $("#passwordr").val()) {
                        $.ajax({
                            url: 'ajax.ashx?action=passwordsub',
                            type: 'post',
                            data: { password: $("#password").val(), passwordn: $("#passwordn").val() },
                            dataType: 'json',
                            success: function (result) {
                                if (result.flag == 'success') {
                                    Messenger().post({
                                        message: "提交成功。",
                                        showCloseButton: true
                                    });
                                }
                                else {
                                    Messenger().post({
                                        message: "提交失败",
                                        type: "error",
                                        showCloseButton: true
                                    });
                                }
                                $("#passwordsub").removeClass("disabled");
                                $("#passwordsub").removeAttr("disabled");
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
                $('#avatarcrop').submit(function (e) {
                    e.preventDefault();
                    $('#avatarsub').addClass('disabled');
                    $('#avatarsub').attr('disabled', "true");
                    $.ajax({
                        url: 'ajax.ashx?action=cropsub',
                        type: 'post',
                        data: { x: $("#x").val(), y: $("#y").val(), w: $("#w").val(), h: $("#h").val()},
                        dataType: 'json',
                        success: function (result) {
                            if (result.flag == 'success') {
                                Messenger().post({
                                    message: "提交成功，刷新来查看新头像。",
                                    showCloseButton: true
                                });
                                $("#avatarcrop").fadeOut("fast", function () {
                                    $("#avatarform").fadeIn();
                                });
                            }
                            else {
                                Messenger().post({
                                    message: "提交失败",
                                    type: "error",
                                    showCloseButton: true
                                });
                            }
                            $("#avatarsub").removeClass("disabled");
                            $("#avatarsub").removeAttr("disabled");
                        }
                    });
                });

                $('#avatarform').submit(function (e) {
                    e.preventDefault();
                    $('#avatarsub').addClass('disabled');
                    $('#avatarsub').attr('disabled', "true");
                    loadScript("js/ajaxfileupload.js", function () {
                        $.ajaxFileUpload({
                            url: "ajax.ashx?action=avatarsub",
                            fileElementId: 'iofile',
                            type: "post",
                            success: function (data) {
                                var result = JSON.parse(data.body.textContent);
                                if (result.flag == 'success') {
                                    Messenger().post({
                                        message: "上传完成，请完成裁切。",
                                        showCloseButton: true
                                    });
                                    $("#avatarform").fadeOut("fast", function () {
                                        $("#target").attr("src", "Photo/c_" + result.data.ipath);
                                        $("img.jcrop-preview").attr("src", "Photo/c_" + result.data.ipath);
                                        $("#avatarcrop").fadeIn();
                                        var jcrop_api,
						                    boundx,
						                    boundy,
						                    $preview = $('#preview-pane'),
						                    $pcnt = $('#preview-pane .preview-container'),
						                    $pimg = $('#preview-pane .preview-container img'),
						                    xsize = $pcnt.width(),
						                    ysize = $pcnt.height();
                                        loadScript("js/jquery.Jcrop.min.js", function () {
                                            loadCSS("css/jquery.Jcrop.min.css", function () { });
                                            $('#target').Jcrop({
                                                onChange: updatePreview,
                                                onSelect: updatePreview,
                                                aspectRatio: 1
                                            }, function () {
                                                var bounds = this.getBounds();
                                                boundx = bounds[0];
                                                boundy = bounds[1];
                                                jcrop_api = this;
                                                console.log(jcrop_api.ui.holder);
                                                $preview.appendTo(jcrop_api.ui.holder);
                                            });
                                            function updatePreview(c) {
                                                if (parseInt(c.w) > 0) {
                                                    var rx = xsize / c.w;
                                                    var ry = ysize / c.h;
                                                    personal_showCoords(c);
                                                    $('div#preview-pane').fadeIn("fast");
                                                    $pimg.css({
                                                        width: Math.round(rx * boundx) + 'px',
                                                        height: Math.round(ry * boundy) + 'px',
                                                        marginLeft: '-' + Math.round(rx * c.x) + 'px',
                                                        marginTop: '-' + Math.round(ry * c.y) + 'px'
                                                    });
                                                }
                                            };
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
                                $('#avatarsub').removeClass('disabled');
                                $('#avatarsub').removeAttr('disabled');
                            }
                        });
                    });
                });

                $('#infoform').submit(function (e) {
                    e.preventDefault();
                    $('#infosub').addClass('disabled');
                    $('#infosub').attr('disabled', "true");
                    $.ajax({
                        url: 'ajax.ashx?action=infosub',
                        type: 'post',
                        data: { birthday: $("#birthday").val(), QQ: $("#QQ").val(), phone: $("#phone").val(), mail: $("#mail").val() },
                        dataType: 'json',
                        success: function (result) {
                            if (result.flag == 'success') {
                                Messenger().post('提交成功。');
                            }
                            else {
                                Messenger().post({
                                    message: "发生系统错误。",
                                    type: 'error',
                                    showCloseButton: true
                                });
                            }
                            $('#infosub').removeClass('disabled');
                            $('#infosub').removeAttr('disabled');
                        }
                    });
                });
            });
            break;
    }
}

function addressBookShowInfo(obj) {
    var UUID = $(obj).data("uuid");
    $.ajax({
        type: "get",
        url: "ajax.ashx?action=getaddressinfo&UUID=" + UUID,
        dataType: 'json',
        success: function (result) {
            console.log(result);
            if (result.flag == 'success') {
                $("#crealname").html(result.data.name);
                $("#cmail").val(result.data.mail);
                $("#cusername").val(result.data.username);
                $("#cbirth").val(result.data.birthday.replace(' 0:00:00', ''));
                $("#cphone").val(result.data.phone);
                $("#cqq").val(result.data.QQ);
                $('#cinfo').modal('show');
            }
        }
    });
}
var bulletinCurrentNotice;
function bulletinShowNotice(obj) {
    var uuid = $(obj).parent().data('id');
    if (bulletinCurrentNotice != uuid) {
        bulletinCurrentNotice = uuid;
        var hideid;
        if ($('#defaultb').css("display") == "none") {
            hideid = 'ntb';
        }
        else {
            hideid = 'defaultb';
        }
        $('#' + hideid).fadeOut("fast", function () {
            $('#ntb').html("<div style='text-align:center'><img src='img/loading.gif' /></div>");
            $('#ntb').fadeIn("fast", function () {
                $.ajax({
                    url: 'ajax.ashx?action=getnotice&GUID=' + uuid,
                    type: 'post',
                    data: '',
                    dataType: 'json',
                    success: function (result) {
                        console.log(result);
                        if (result.flag == 'success') {
                            $('ul.bs-sidenav .active').removeClass('active');
                            $('#' + uuid).addClass('active');
                            $('#ntb').fadeOut("fast", function () {
                                var base = new Base64();
                                $('#titlebar').addClass('active');
                                $('#titlebar').html(result.data.title);
                                $('#titlebar').fadeIn("fast");
                                $('#ntb').html("<div class='page-header'><h1>" + result.data.title + "</h1></div><div>" + base.decode(result.data.cont) + "</div>");
                                $('#ntb').fadeIn("fast");
                            });
                        }
                    }
                });
            });
        });
    }
}

var fileLibCurrentFile;
var fileLibCurrentName;
function fileLibLoadDate(obj) {
    var date = $(obj).data('date');
    $('#datelist li').removeClass('active');
    $(obj).parent().addClass('active');
    $.ajax({
        url: 'ajax.ashx?action=getfilelist&date=' + date,
        type: 'post',
        data: '',
        dataType: 'json',
        success: function (result) {
            console.log(result);
            if (result.flag == 'success') {
                $('#filelist').fadeOut("fast", function () {
                    var base = new Base64();
                    $('#filelist').html(base.decode(result.data.html));
                    $("#filelist").fadeIn("fast");
                });
            }
        }
    });
}
function fileLibSelectFile(obj) {
    $('#infospan').fadeOut("fast", function () {
        fileLibCurrentName = $(obj).html();
        fileLibCurrentFile = "Doc/" + $(obj).data("path");
        $('#filethumbname').html(fileLibCurrentName);
        $('#filename').html(fileLibCurrentName);
        $('#fileurl').attr("href", "File.ashx?file=" + $(obj).data("path"));
        $('#fileurl2').attr("href", "File.ashx?file=" + $(obj).data("path"));
        $('#infospan').fadeIn("fast");
    });
}

function fileLibThumbFile() {
    $('#fileframe').attr("src", encodeURI("http://view.officeapps.live.com/op/view.aspx?src=http://c13.name/File.ashx?file=" + fileLibCurrentFile));
    $('#filethumbm').modal('show');
}

function homeworkLoadDate(obj) {
    var date = $(obj).data('date');
    $('#filedate li').removeClass('active');
    $(obj).parent().addClass('active');
    $.ajax({
        url: 'ajax.ashx?action=gethomeworklist&date=' + date,
        type: 'get',
        dataType: 'json',
        success: function (result) {
            if (result.flag == 'success') {
                $('#filelist').fadeOut("fast", function () {
                    var base = new Base64();
                    $('#filelist').html(base.decode(result.data.html));
                    $("#filelist").fadeIn("fast");
                });
            }
        }
    });
}

function personal_showCoords(c) {
    jQuery('#x').val(c.x);
    jQuery('#y').val(c.y);
    jQuery('#x2').val(c.x2);
    jQuery('#y2').val(c.y2);
    jQuery('#w').val(c.w);
    jQuery('#h').val(c.h);
}

function loadScript(url, callback) {
    var script = document.createElement("script");
    script.type = "text/javascript";
    //IE
    if (script.readyState) {
        script.onreadystatechange = function () {
            if (script.readyState == "loaded" || script.readyState == "complete") {
                script.onreadystatechange = null;
                callback();
            }
        }
    } else {
        //non-IE
        script.onload = function () {
            callback();
        }
    }
    script.src = url;
    document.getElementById("head").appendChild(script);
}

function loadCSS(url, callback) {
    var script = document.createElement("link");
    script.rel = "stylesheet";
    if (script.readyState) {
        script.onreadystatechange = function () {
            if (script.readyState == "loaded" || script.readyState == "complete") {
                script.onreadystatechange = null;
                callback();
            }
        }
    } else {
        //non-IE
        script.onload = function () {
            callback();
        }
    }
    script.href = url;
    document.getElementById("head").appendChild(script);
}

loadScript("js/jquery.min.js", function () {
    loadScript("js/bootstrap.min.js", function () { });
    loadScript("js/base64.js", function () { });
    loadScript("js/messenger.min.js", function () {
        loadCSS("css/messenger.css", function () { });
        loadCSS("css/messenger-theme-flat.css", function () { });
        loadScript("js/messenger-theme-flat.js", function () {
            Messenger.options = {
                extraClasses: 'messenger-fixed messenger-on-bottom',
                theme: 'flat'
            }
        });
    });
    loadScript("js/jquery.scrollUp.min.js", function () {
        $.scrollUp({
            scrollDistance: 300,
            scrollFrom: 'top',
            scrollSpeed: 300,
            easingType: 'linear',
            animation: 'fade',
            scrollText: '',
            scrollImg: true,
            zIndex: 10
        });
    });
    talkInit();
    pageScript(window.location.pathname.replace('/', '').replace('.aspx', '').toLowerCase());
});