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
            global_onlogout();
            Messenger().post({
                message: result.data.info,
                showCloseButton: true
            });
            window.location.href = 'Login.aspx';
        }
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

function Script(page) {
    switch (page) {
        case "addressbook":
            addressbook_getinfo();
            break;
        case "bulletin":
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
                            if (result.flag == 'info')
                            {
                                Messenger().post({
                                    message: '请输入关键字。',
                                    showCloseButton: true
                                });
                            }
                            else if (result.flag == 'success')
                            {
                                if (result.data.length == 0) {
                                    Messenger().post({
                                        message: '查找到0条结果。',
                                        showCloseButton: true
                                    });
                                }
                                else
                                {
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
            $(function () {
                $("[name='iocheck']").bootstrapSwitch();
                $("[name='iocheck']").on('switchChange.bootstrapSwitch', function () {
                    $("#sendb").toggle("fast");
                });
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
                        success: function (data) {
                            if (data == "OK") {
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
        case "gallery":
            $(function () {
                $(".swipebox").swipebox();
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
                $("#ioformsub").submit(function (e) {
                    e.preventDefault();
                    $("#iosub").addClass("disabled");
                    $("#iosub").attr("disabled", "true");
                    $.ajaxFileUpload({
                        url: "ajax.ashx?action=photosub&title=" + $("#title").val(),
                        fileElementId: 'iofile',
                        type: "post",
                        success: function (data) {
                            Messenger().post({
                                message: "提交成功。",
                                showCloseButton: true
                            });
                            $("#ioformsub")[0].reset();
                            $("#iosub").removeClass("disabled");
                            $("#iosub").removeAttr("disabled");
                            $('#iomodal').modal('hide');
                            global_reloadpage("Gallery");
                        },
                        error: function (obj) {
                            $("#iosub").removeClass("disabled");
                            $("#iosub").removeAttr("disabled");
                            Messenger().post({
                                message: "提交失败",
                                type: "error",
                                showCloseButton: true
                            });
                        }
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

                var dataString = "iocont=" + rcont;
                $.ajax({
                    url: "ajax.ashx?action=homeworksub",
                    type: "post",
                    data: dataString,
                    success: function (data) {
                        if (data == "OK") {
                            Messenger().post({
                                message: "提交成功。",
                                showCloseButton: true
                            });
                            $("#ioformsub")[0].reset();
                            $("#iosub").removeClass("disabled");
                            $("#iosub").removeAttr("disabled");
                            $('#iomodal').modal('hide');
                            global_reloadpage("Homework");
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

            break;
        case "personal":
            $(function () {
                var jcrop_api,
						boundx,
						boundy,
						$preview = $('#preview-pane'),
						$pcnt = $('#preview-pane .preview-container'),
						$pimg = $('#preview-pane .preview-container img'),

						xsize = $pcnt.width(),
						ysize = $pcnt.height();

                console.log('init', [xsize, ysize]);
                $('#target').Jcrop({
                    onChange: updatePreview,
                    onSelect: updatePreview,
                    aspectRatio: 1
                }, function () {
                    var bounds = this.getBounds();
                    boundx = bounds[0];
                    boundy = bounds[1];
                    jcrop_api = this;
                    $preview.appendTo(jcrop_api.ui.holder);
                });
                function updatePreview(c) {
                    if (parseInt(c.w) > 0) {
                        var rx = xsize / c.w;
                        var ry = ysize / c.h;
                        personal_showCoords(c);
                        $('div#preview-pane').fadeIn(300);
                        $pimg.css({
                            width: Math.round(rx * boundx) + 'px',
                            height: Math.round(ry * boundy) + 'px',
                            marginLeft: '-' + Math.round(rx * c.x) + 'px',
                            marginTop: '-' + Math.round(ry * c.y) + 'px'
                        });
                    }
                };
            });
            break;
    }
}


function addressbook_getinfo() {
    $.ajax({
        type: "get",
        url: "ajax.ashx?action=getaddressbook",
        success: function (result) {
            $("#cardcont").fadeOut("fast", function () {
                $("#cardcont").html(result);
                $("#cardcont").css("opacity", "0");
                $("#cardcont").slideDown("slow", function () {
                    $("#cardcont").animate({ "opacity": "1" }, "slow");
                });
            });
        }
    });
}
function addressbook_showinfo(UUID) {
    $.ajax({
        type: "get",
        url: "ajax.ashx?action=getaddressinfo&UUID=" + UUID,
        success: function (data) {
            var strs = new Array();
            strs = data.split(",");
            $("#crealname").html(strs[1]);
            $("#cmail").val(strs[2]);
            $("#cusername").val(strs[0]);
            $("#cbirth").val(strs[4]);
            $("#cphone").val(strs[5]);
            $("#cqq").val(strs[3]);
            $('#cinfo').modal('show');
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

var filelib_currentfile;
var filelib_currentname;
function filelib_loaddate(date) {
    $('#datelist li').removeClass('active');
    $('#' + date.replace('/', 'd').replace('/', 'd').replace('/', 'd')).addClass('active');
    $.ajax({
        url: 'ajax.ashx?action=getfilelist&date=' + date,
        type: 'post',
        data: '',
        success: function (data) {
            $('#filelist').fadeOut("fast", function () {
                $('#filelist').html(data);
                $("#filelist").fadeIn("fast");
            });
        }
    });
}
function filelib_selectfile(sel) {
    $('#infospan').fadeOut("fast", function () {
        filelib_currentname = $(sel).html();
        filelib_currentfile = "Doc/" + $(sel).attr("id");
        $('#filethumbname').html(filelib_currentname);
        $('#filename').html(filelib_currentname);
        $('#fileurl').attr("href", "ajax.ashx?action=getfile&file=" + $(sel).attr("id"));
        $('#fileurl2').attr("href", "ajax.ashx?action=getfile&file=" + $(sel).attr("id"));
        $('#infospan').fadeIn("fast");
    });
}

function filelib_thumbfile() {
    $('#fileframe').attr("src", encodeURI("http://view.officeapps.live.com/op/view.aspx?src=http://c13.name/" + filelib_currentfile));
    $('#filethumbm').modal('show');
}

function homework_loaddate(date) {

    $('#filedate li').removeClass('active');
    $('#' + date.replace('/', 'd').replace('/', 'd').replace('/', 'd')).addClass('active');
    $.ajax({
        url: 'ajax.ashx?action=gethomeworklist&date=' + date,
        type: 'post',
        data: '',
        success: function (data) {
            $('#filelist').fadeOut("fast", function () {
                $('#filelist').html(data);
                $("#filelist").fadeIn("fast");
            });
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

$(function () {
    Messenger.options = {
        extraClasses: 'messenger-fixed messenger-on-bottom',
        theme: 'flat'
    }

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
                console.log(result);
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
});