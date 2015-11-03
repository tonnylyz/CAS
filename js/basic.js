function Dictionary() {
    this.data = new Array();
    this.put = function (key, value) {
        this.data[key] = value;
    };
    this.get = function (key) {
        return this.data[key];
    };
    this.remove = function (key) {
        this.data[key] = null;
    };
    this.isEmpty = function () {
        return this.data.length == 0;
    };
    this.size = function () {
        return this.data.length;
    };
}
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
    window.location.href = "Login.aspx?action=logout";
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
                            $("#talkcontent").append('<div class=\"talkcard\" data-id=\"' + result.data[i].GUID + '\"><div class=\"talkcardhead\"><img id=\"userhead\" src=\"photo/' + result.data[i].UUID + '.jpg\" height=\"40px\" width=\"40px\"></div><div class=\"talkcardinfo\"><p class=\"talkoptitle\">' + result.data[i].name + '@' + result.data[i].username + '</p><p class=\"talkoptitlerd\"><a onclick=\"talkRead(this)\">×</a> | <a onclick=\"talkGood(this)\">赞</a></p></div><div class=\"talkcardtime\">' + result.data[i].date + '</div><div class=\"talkcardcontent\">' + result.data[i].cont + '</div></div>');
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
                        $("#talkcontent").append('<div class=\"talkcard\" data-id=\"' + result.data[i].GUID + '\"><div class=\"talkcardhead\"><img id=\"userhead\" src=\"photo/' + result.data[i].UUID + '.jpg\" height=\"40px\" width=\"40px\"></div><div class=\"talkcardinfo\"><p class=\"talkoptitle\">' + result.data[i].name + '@' + result.data[i].username + '</p><p class=\"talkoptitlerd\"><a onclick=\"talkRead(this)\">×</a> | <a onclick=\"talkGood(this)\">赞</a></p></div><div class=\"talkcardtime\">' + result.data[i].date + '</div><div class=\"talkcardcontent\">' + result.data[i].cont + '</div></div>');
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
        case "":
        case "default":
            $(function () {
                $.ajax({
                    type: "get",
                    url: "ajax.ashx?action=getbirthday",
                    dataType: 'json',
                    success: function (result) {
                        if (result.flag == 'success') {
                            for (var i = 0; i < result.data.length; i++)
                                $("#birthday").append("<tr><th>" + result.data[i].name + "</th><th>" + result.data[i].birthday + "</th></tr>");
                        }
                    }
                });
            });

            break;
        case "addressbook":
            $.ajax({
                type: "get",
                url: "ajax.ashx?action=getaddressbook",
                dataType: 'json',
                success: function (result) {
                    if (result.flag == 'success') {
                        $("#cardcont").fadeOut("fast", function () {
                            for (var i = 0; i < result.data.length; i++)
                                $("#cardcont").append('<div class=\"col-sm-4 cardspan\"><div class=\"infocard\"><a data-uuid=\"' + result.data[i].UUID + '\" onclick=\"addressBookShowInfo(this)\"><img src=\"photo/' + result.data[i].UUID + '.jpg\" /><h4>' + result.data[i].name + ' <small>@' + result.data[i].username + '</small></h4></a></div></div>');
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
            loadScript("//cdn.bootcss.com/tinymce/4.2.7/tinymce.min.js", function () {
                tinymce.init({
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
                /*$('#searchformid').submit(function (e) {
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
                });*/
                $("#ioformsub").submit(function (e) {
                    e.preventDefault();
                    $("#iosub").addClass("disabled");
                    $("#iosub").attr("disabled", "true");
                    $.ajax({
                        url: "ajax.ashx?action=noticesub",
                        type: "post",
                        data: { iocont: Base64.encode(tinyMCE.get('iocontent').getContent()), iotitle: $("#iotitle").val() },
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
            loadScript("//cdn.bootcss.com/bootstrap-datetimepicker/4.17.37/js/bootstrap-datetimepicker.min.js", function () {
                loadCSS("//cdn.bootcss.com/bootstrap-datetimepicker/4.17.37/css/bootstrap-datetimepicker.min.css", function () { });
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
            loadScript("//cdn.bootcss.com/bootstrap-switch/3.3.2/js/bootstrap-switch.min.js", function () {
                loadCSS("//cdn.bootcss.com/bootstrap-switch/3.3.2/css/bootstrap3/bootstrap-switch.min.css", function () { });
                $("[name='iocheck']").bootstrapSwitch();
                $("[name='iocheck']").on('switchChange.bootstrapSwitch', function () {
                    $("#sendb").toggle("fast");
                });
            });

            loadScript("//cdn.bootcss.com/fullcalendar/2.4.0/fullcalendar.min.js", function () {
                loadCSS("//cdn.bootcss.com/fullcalendar/2.4.0/fullcalendar.min.css", function () { });
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
            loadScript("//cdn.bootcss.com/jquery.swipebox/1.4.1/js/jquery.swipebox.min.js", function () {
                loadCSS("//cdn.bootcss.com/jquery.swipebox/1.4.1/css/swipebox.min.css", function () { });
                $(".swipebox").swipebox();
            });
            loadScript("//cdn.bootcss.com/mixitup/2.1.11/jquery.mixitup.min.js", function () {
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
                    loadScript("https://raw.githubusercontent.com/davgothic/AjaxFileUpload/master/jquery.ajaxfileupload.js", function () {
                        $.ajaxFileUpload({
                            url: "ajax.ashx?action=photosub&title=" + $("#title").val(),
                            fileElementId: 'iofile',
                            type: "post",
                            success: function (data) {
                                var result = JSON.parse(data.body.textContent);
                                console.log(result);
                                if (result.flag == 'success') {
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
                                    $("#histalkct").append('<div><img style=\"float:left;margin:5px\" src=\"photo/' + result.data[i].UUID + '.jpg\" height=\"40px\" width=\"40px\"/><h4 style=\"float:left;padding-top:10px\">' + result.data[i].name + '：</h4><p style=\"clear:both\">' + result.data[i].cont + '</p><p style=\"text-align:right;color:#ccc;\">' + result.data[i].date + '</p></div><hr>');
                            $("#histalkct").css("opacity", "0");
                            $("#histalkct").slideDown('slow', function () {
                                $("#histalkct").animate({ "opacity": "1" }, "slow");
                            });
                        });
                    }

                }
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
                            $("#mail").val(result.data.mail);
                            $("#university").val(result.data.university);
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
                    loadScript("https://raw.githubusercontent.com/davgothic/AjaxFileUpload/master/jquery.ajaxfileupload.js", function () {
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
                                        $("#target").attr("src", "photo/c_" + result.data.ipath);
                                        $("img.jcrop-preview").attr("src", "photo/c_" + result.data.ipath);
                                        $("#avatarcrop").fadeIn();
                                        var jcrop_api,
						                    boundx,
						                    boundy,
						                    $preview = $('#preview-pane'),
						                    $pcnt = $('#preview-pane .preview-container'),
						                    $pimg = $('#preview-pane .preview-container img'),
						                    xsize = $pcnt.width(),
						                    ysize = $pcnt.height();
                                        loadScript("//cdn.bootcss.com/jquery-jcrop/0.9.12/js/jquery.Jcrop.min.js", function () {
                                            loadCSS("//cdn.bootcss.com/jquery-jcrop/0.9.12/css/jquery.Jcrop.min.css", function () { });
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
                        data: { birthday: $("#birthday").val(), QQ: $("#QQ").val(), phone: $("#phone").val(), mail: $("#mail").val(), university: $("#university").val() },
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
        case "earth":
            loadScript("http://www.webglearth.com/v2/api.js", function () {
                $("#earth_div").css("height", window.innerHeight);
                var earth = new WE.map('earth_div');

        WE.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',{
          attribution: '© OpenStreetMap contributors'
        }).addTo(earth);

                
				var university = new Dictionary();
				university.put("北京大学",  {lat: 39.986913, lng: 116.3058739 });
				university.put("北京航天航空大学", {lat: 39.982826, lng: 116.353931 });
				university.put("北京理工大学", {lat: 39.7174289802915, lng: 116.092143980291 });
				university.put("北京师范大学", {lat: 39.9619537, lng: 116.3662615 });
				university.put("北京邮电大学", {lat: 39.962796, lng: 116.358103 });
				university.put("大连海事大学", {lat: 38.870041, lng: 121.534141 });
				university.put("电子科技大学", {lat: 30.675104, lng: 104.100361 });
				university.put("东北大学", {lat: 41.7697444, lng: 123.4197519 });
				university.put("广东外语外贸大学", {lat: 23.0637099802915, lng: 113.401560980291 });
				university.put("湖南大学", {lat: 28.179012, lng: 112.943822 });
				university.put("吉林大学", {lat: 43.882562, lng: 125.307669 });
				university.put("暨南大学", {lat: 23.128057, lng: 113.347721 });
				university.put("加州大学圣地亚哥分校", {lat: 32.8800604, lng: -117.2340135 });
				university.put("康奈尔大学", {lat: 46.72112, lng: -118.7838579 });
				university.put("兰州大学", {lat: 36.0477699, lng: 103.8585624 });
				university.put("密歇根大学", {lat: 43.5912088, lng: -84.7751384 });
				university.put("南方医科大学", {lat: 22.790184, lng: 113.228722 });
				university.put("清华大学", {lat: 39.9996674, lng: 116.3264439 });
				university.put("厦门大学", {lat: 24.4373484, lng: 118.097855 });
				university.put("上海交通大学", {lat: 31.202264, lng: 121.435256 });
				university.put("深圳大学", {lat: 22.5340033, lng: 113.937192 });
				university.put("武汉大学", {lat: 30.5360485, lng: 114.3643219 });
				university.put("西安电子科技大学", {lat: 34.235138, lng: 108.9185219 });
				university.put("悉尼大学", {lat: -33.888584, lng: 151.1873473 });
				university.put("香港大学", {lat: 22.2829989, lng: 114.1370848 });
				university.put("香港科技大学", {lat: 22.3363998, lng: 114.2654655 });
				university.put("香港中文大学", {lat: 22.4215144, lng: 114.2078426 });
				university.put("浙江大学", {lat: 30.263608, lng: 120.1234389 });
				university.put("中北大学", {lat: 38.009274, lng: 112.442602 });
				university.put("中国科技大学", {lat: 31.8412799, lng: 117.268863 });
				university.put("中国人民大学", {lat: 39.966924, lng: 116.321391 });
				university.put("中国药科大学", {lat: 31.89791, lng: 118.913745 });
				university.put("中山大学", {lat: 23.0963779, lng: 113.2988285 });
				university.put("中山大学(珠海)", {lat: 22.341292, lng: 113.589776 });
	
				$.ajax({
					type: "get",
					url: "ajax.ashx?action=getearth",
					dataType: 'json',
					success: function (result) {
						if (result.flag == 'success') {
							for (var i = 0; i < result.data.length; i++) {
								var uni = university.get(result.data[i].university);
								var marker = WE.marker([uni.lat, uni.lng]).addTo(earth);
								var student = result.data[i].student;
								var popup = "<h5>" + result.data[i].university + "</h5>";
								popup += "<ul class=\"list-group\">";
								for (var j = 0; j < student.length; j++)
									popup += "<li class=\"list-group-item\"><img alt=\" \" src=\"photo/" + student[j].UUID + ".jpg\">" + student[j].name + "</li> ";
								popup += "</ul>";
								marker.bindPopup(popup, { maxWidth: 120, closeButton: true });
							}
						}
					}
				});
                earth.setView([22.552947, 114.120626], 4);
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
                        if (result.flag == 'success') {
                            $('ul.bs-sidenav .active').removeClass('active');
                            $('#' + uuid).addClass('active');
                            $('#ntb').fadeOut("fast", function () {
                                $('#titlebar').addClass('active');
                                $('#titlebar').html(result.data.title);
                                $('#titlebar').fadeIn("fast");
                                $('#ntb').html("<div class='page-header'><h1>" + result.data.title + "</h1></div><div>" + Base64.encode(result.data.cont) + "</div>");
                                $('#ntb').fadeIn("fast");
                            });
                        }
                    }
                });
            });
        });
    }
}

function personal_showCoords(c) {
    $('#x').val(c.x);
    $('#y').val(c.y);
    $('#x2').val(c.x2);
    $('#y2').val(c.y2);
    $('#w').val(c.w);
    $('#h').val(c.h);
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

loadScript("//cdn.bootcss.com/jquery/2.1.4/jquery.min.js", function () {
    loadScript("//cdn.bootcss.com/bootstrap/3.3.5/js/bootstrap.min.js", function () { });
    loadScript("https://raw.githubusercontent.com/dankogai/js-base64/master/base64.min.js", function () { });
    loadScript("//cdn.bootcss.com/messenger/1.4.2/js/messenger.min.js", function () {
        loadCSS("//cdn.bootcss.com/messenger/1.4.2/css/messenger.min.css", function () { });
        loadCSS("//cdn.bootcss.com/messenger/1.4.2/css/messenger-theme-flat.min.css", function () { });
        loadScript("//cdn.bootcss.com/messenger/1.4.2/js/messenger-theme-flat.min.js", function () {
            Messenger.options = {
                extraClasses: 'messenger-fixed messenger-on-bottom',
                theme: 'flat'
            }
        });
    });
    loadScript("https://raw.githubusercontent.com/markgoodyear/scrollup/master/dist/jquery.scrollUp.min.js", function () {
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
    pageScript(window.location.pathname.replace('/', '').toLowerCase().replace('.aspx', ''));
});
