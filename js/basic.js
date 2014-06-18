var global_login;
var global_UUID;
var global_username;
var global_realname;
var global_permission;
var global_frame;

function global_logincheck()
{
    $.ajax({
        url: 'ajax.ashx?action=logincheck',
        type: 'get',
        async: false,
        success: function (data) {
            var str = data.split(',');
            if (str[0] == 'success')
            {
                global_UUID = str[1];
            }
        }
    });
}

function global_userinfo(UUID)
{
    $.ajax({
        url: 'ajax.ashx?action=userinfo&UUID=' + UUID,
        type: 'get',
        async: false,
        success: function (data) {
            var str = data.split(',');
            if (str[0] == 'success')
            {
                global_username = str[1];
                global_realname = str[2];
                global_permission = str[3].split('-');
                
            }
        }
    });
}

function global_userinitial()
{
    $('#naviconbar ul').css('display', 'none');

    if (global_login)
    {
        $('#naviconbar #userbtn a').html('<img src="Photo/' + global_realname + '.jpg"/><span>' + global_username + '</span>');

        $('#naviconbar #talkbtn').fadeIn('fast');
        $('#naviconbar #userbtn').fadeIn('fast');

        $('#userframe #userheadbox').html('<img src="Photo/' + global_realname + '.jpg"/>');
    }
    else
    {
        $('#naviconbar #loginbtn a').html('<img src="img/icon.login.png"/><span>登录</span>');

        $('#naviconbar #loginbtn').fadeIn('fast');
    }
}

function global_loadframe(frame)
{
    if (global_frame){
        $('#' + global_frame + 'frame').fadeOut('fast', function () {
            switch (frame) {
                case 'login':
                    $('#loginframe').fadeIn('fast');
                    global_frame = 'login';
                    break;
                case 'talk':
                    $('#talkframe').fadeIn('fast');
                    global_frame = 'talk';
                    talk_get();
                    break;
                case 'user':
                    $('#userframe').fadeIn('fast');
                    global_frame = 'user';
                    break;
            }
        });
    }
    else
    {
        switch (frame)
        {
            case 'login':
                $('#loginframe').fadeIn('fast');
                global_frame = 'login';
                break;
            case 'talk':
                $('#talkframe').fadeIn('fast');
                talk_get();
                global_frame = 'talk';

                break;
            case 'user':
                $('#userframe').fadeIn('fast');
                global_frame = 'user';
                break;
        }
    }
}

function global_hideframe()
{
    $('#' + global_frame + 'frame').fadeOut('fast');
}

function global_logout() {
    global_login = false;
    global_userinfo = null;
    global_username = null;
    global_realname = null;
    global_permission = null;
    global_UUID = null;

    $.ajax({
        url: 'ajax.ashx?action=logout',
        type: 'get',
        success: function (data) {
            global_onlogout();
            Messenger().post({
                message: '注销成功。',
                showCloseButton: true
            });
        }
    });

    global_hideframe();
    global_userinitial();
}

var talk_got = false;
function talk_get() {
    if (!talk_got) {
        $("#talkcontent").html("<div style='margin-left:90px'><img src='img/loading.gif'/></div>");
        $.ajax({
            type: "get",
            url: "ajax.ashx?action=gettalk",
            success: function (result) {
                $("#talkcontent").fadeOut("fast", function () {
                    $("#talkcontent").css("display", "none");
                    if (result != "") {
                        $("#talkcontent").html(result);
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
        talk_got = true;
    }
    else {
        $.ajax({
            type: "get",
            url: "ajax.ashx?action=gettalk",
            success: function (result) {
                if (result != "") {
                    $("#talkcontent").html(result);
                }
                else {
                    $("#talkcontent").html("暂无未读消息");
                }
            }
        });
    }
}


function talk_read(ID) {
    var box = "#tc" + ID;
    $(box).animate({ "opacity": "0" }, function () { $(box).slideUp(); });
    $.ajax({
        type: "get",
        url: "ajax.ashx?action=talkread&TUID=" + ID,
    });
}

function talk_good(ID) {
    var box = "#tc" + ID;
    $(box).animate({ "opacity": "0" }, function () { $(box).slideUp(); });
    $.ajax({
        type: "get",
        url: "ajax.ashx?action=talkgood&TUID=" + ID,
    });
}

function global_script(page)
{
	switch (page) {
	    case "addressbook":
	        $(function () {
	            if (global_login)
	                addressbook_getinfo();
	        });
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

			    if (global_permission && global_permission[4] == "1") {
			        $("#iomodalbt").fadeIn("fast");
			    }
				$('#searchformid').submit(function (e) {
					e.preventDefault();
					$('#searchsub').addClass('disabled');
					$('#searchsub').attr('disabled', "true");
					$.ajax({
						type: 'get',
						url: 'ajax.ashx?action=getbulletin&searchkey=' + $('#searchkey').val(),
						success: function (data) {
							$('#searchkey').val('');
							$('#searchsub').removeClass('disabled');
							$('#searchsub').removeAttr('disabled');
							if (data != '<li>无</li>') {
								$('#bultlist').slideUp("fast", function () {
									$('#bultlist').css("display", "none");
									$('#bultlist').html(data);
									$("#bultlist").slideDown("slow");
								});

								Messenger().post({
									message: '结果已在目录中显示。',
									showCloseButton: true
								});
							}
							else {
								Messenger().post({
									message: '查找到0条结果。',
									showCloseButton: true
								});
							}
						},
					});
				});
				$("#ioformsub").submit(function (e) {
					e.preventDefault();
					$("#iosub").addClass("disabled");
					$("#iosub").attr("disabled", "true");
					$.ajax({
						url: "ajax.ashx?action=noticesub",
						type: "post",
						data: { iocont: tinyMCE.get('iocontent').getContent(), iotitle: $("#iotitle").val() },
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
					var dataString = "ioinfo=" + $("#ioinfo").val() + "&iosta=" + $("#iosta").val() + "&ioend=" + $("#ioend").val();
					$.ajax({
						url: "ajax.ashx?action=calendarsub",
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
			    if (global_permission && global_permission[3] == '1')
				    $("#iomodalbt").fadeIn();
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
					var ionum = $("#ionum").val();
					if ($("#iocheck").is(':checked') == false) {
						ionum = "-" + $("#ionum").val();
					}
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
				if (global_permission && global_permission[2] == '1')
				    $("#iomodalbt").fadeIn();
			});

			break;
	    case "talk":
	        $(function () {
	            if (global_login) {
	                talk_load();
	            }
	        });

			break;
	    case "homework":
	        $(function () {
	            if (global_permission && global_permission[6] != '0')
	                $("#iomodalbt").fadeIn();

	        });
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
var bulletin_currentnotice;
function bulletin_shownotice(uuid) {
    if (bulletin_currentnotice != uuid) {
        bulletin_currentnotice = uuid;
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
                    url: 'Ajax.ashx?action=getnotice&GUID=' + uuid,
                    type: 'post',
                    data: '',
                    success: function (data) {
                        var strs = new Array();
                        strs = data.split("}{");
                        $('ul.bs-sidenav .active').removeClass('active');
                        $('#' + uuid).addClass('active');
                        $('#ntb').fadeOut("fast", function () {
                            $('#titlebar').addClass('active');
                            $('#titlebar').html(strs[0]);
                            $('#titlebar').fadeIn("fast");
                            $('#ntb').html("<div class='page-header'><h1>" + strs[0] + "</h1></div><div>" + strs[3] + "</div>");
                            $('#ntb').fadeIn("fast");
                        });
                    }
                });
            });
        });
    }
}
function talk_load(){
    $('.alert').slideUp();
    $("#histalkct").html("<div style='text-align:center'><img src='img/loading.gif'/></div>");
    $("#histalkct").fadeIn("fast", function () {
        $.ajax({
            type: "post",
            url: "ajax.ashx?action=gethistalk",
            dataType: "html",
            data: "",
            success: function (result) {
                $("#histalkct").fadeOut("fast", function () {
                    $("#histalkct").css("display", "none");
                    $("#histalkct").html(result);
                    $("#histalkct").css("opacity", "0");
                    $("#histalkct").slideDown('slow', function () {
                        $("#histalkct").animate({ "opacity": "1" }, "slow");
                    });
                });
            }
        });
    });
}

var filelib_currentfile;
var filelib_currentname;
function filelib_loaddate(date) {
    $('#datelist li').removeClass('active');
    $('#' + date.replace('/', 'd').replace('/', 'd').replace('/', 'd')).addClass('active');
    $.ajax({
        url: 'Ajax.ashx?action=getfilelist&date=' + date,
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
        zIndex: 2147483647
    });

    $('#talkform').submit(function (e) {
        e.preventDefault();
        $('#talksub').addClass('disabled');
        $('#talksub').attr('disabled', "true");
        $.ajax({
            url: 'ajax.ashx?action=talksub',
            type: 'post',
            data: 'talksubct=' + $('#talksubct').val(),
            success: function (data) {
                if (data == 'OK') {
                    Messenger().post('提交成功。');
                    $('#talksubct').val('');
                    $('#talksub').removeClass('disabled');
                    $('#talksub').removeAttr('disabled');
                }
                else {
                    $('#talksubbt').removeClass('disabled');
                    $('#talksubbt').removeAttr('disabled');
                    Messenger().post({
                        message: "提交错误。",
                        type: 'error',
                        showCloseButton: true
                    });
                }
            }
        });
    });
    $('#loginform').submit(function (e) {
        e.preventDefault();
        $('#loginsub').addClass('disabled');
        $('#loginsub').attr('disabled', "true");
        var dataString = 'username=' + $('#username').val() + '&password=' + $('#password').val();
        $.ajax({
            url: 'ajax.ashx?action=login',
            type: 'post',
            data: dataString,
            success: function (data) {
                if (data == 'OK') {
                    Messenger().post('登录成功。');
                    global_hideframe();
                    $('#username').val('');
                    $('#password').val('');
                    global_logincheck();
                    global_login = true;
                    global_userinfo(global_UUID);
                    global_onlogin();
                    global_userinitial();
                    $('#loginsub').removeClass('disabled');
                    $('#loginsub').removeAttr('disabled');
                }
                else {
                    $('#loginsub').removeClass('disabled');
                    $('#loginsub').removeAttr('disabled');
                    if (data == '') {
                        global_logincheck();
                        global_login = true;
                        global_userinfo(global_UUID);
                        global_userinitial();
                    } else {
                        Messenger().post({
                            message: data,
                            type: 'error',
                            showCloseButton: true
                        });
                    }
                }
            }
        });
    });
    global_userinitial();
});