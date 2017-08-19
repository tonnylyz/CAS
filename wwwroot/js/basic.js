function Dictionary() {
    this.data = [];
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
        return this.data.length === 0;
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
                case 'user':
                    $('#userframe').fadeIn('fast');
                    frameCurrent = 'user';
                    break;
            }
        });
    }
    else {
        switch (frame) {
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
    window.location.href = "Ajax/Logout";
}

function pageScript(page) {
    switch (page) {
        case "":
        case "index":
            $(function () {
                $.ajax({
                    type: "get",
                    url: "Ajax/GetBirthday",
                    dataType: 'json',
                    success: function (data) {
                        for (var i = 0; i < data.length; i++)
                            $("#birthday").append(
                                "<tr><th>" + data[i].name + "</th><th>"
                                + data[i].birthday.replace("T00:00:00", "") + "</th></tr>");
                    }
                });
            });

            break;
        case "login":
            $('#login-form').submit(function (e) {
                e.preventDefault();
                var btn = $('#loginsub');
                btn.addClass('disabled');
                btn.attr('disabled', "true");
                $.ajax({
                    url: 'Ajax/Login',
                    type: 'post',
                    data: {'username': $('#username').val(), 'password': $('#password').val()},
                    dataType: "json",
                    success: function (result) {
                        if (result.flag === 'success') {
                            Messenger().post(result.data);
                            window.location.href = 'Index';
                        }
                        else {
                            Messenger().post({
                                message: result.data,
                                type: 'error',
                                showCloseButton: true
                            });
                        }
                        btn.removeClass('disabled');
                        btn.removeAttr('disabled');
                    }
                });
            });
            break;
        case "addressbook":
            $.ajax({
                type: "get",
                url: "Ajax/GetAddressbook",
                dataType: 'json',
                success: function (data) {
                    var cardcont = $("#cardcont");
                    cardcont.fadeOut("fast", function () {
                        for (var i = 0; i < data.length; i++)
                            cardcont.append('<div class=\"col-sm-4 cardspan\"><div class=\"infocard\"><a data-id=\"' +
                                data[i].ID + '\" onclick=\"addressBookShowInfo(this)\"><img src=\"photo/' +
                                data[i].UUID + '.jpg\" /><h4>' +
                                data[i].name + ' <small>@' +
                                data[i].username + '</small></h4></a></div></div>');
                        cardcont.css("opacity", "0");
                        cardcont.slideDown("slow", function () {
                            cardcont.animate({"opacity": "1"}, "slow");
                        });
                    });
                },
                error: function () {
                    $("#cardcont").html("<p>需要登录才可查看该页面</p>");
                }
            });
            break;
        case "bulletin":
            break;
        case "calendar":
            loadScript("https://cdn.bootcss.com/moment.js/2.18.1/moment.min.js", function () {
                loadScript("https://cdn.bootcss.com/fullcalendar/3.4.0/fullcalendar.min.js", function () {
                    loadCSS("https://cdn.bootcss.com/fullcalendar/3.4.0/fullcalendar.min.css", function () {
                    });
                    $.ajax({
                        url: "Ajax/GetCalendar",
                        type: "get",
                        dataType: 'json',
                        success: function (data) {
                            for (var i = 0; i < data.length; i++) {
                                var start = data[i].startstr.split('-');
                                data[i].start = new Date(start[0], start[1] - 1, start[2]);
                                if (data[i].endstr) {
                                    var end = data[i].endstr.split('-');
                                    data[i].end = new Date(end[0], end[1] - 1, end[2]);
                                }
                            }
                            $('#calendar').fullCalendar({editable: false, allDayDefault: true, events: data});
                        }
                    });
                });

            });
            break;
        case "gallery":
            loadScript("https://cdn.bootcss.com/jquery.swipebox/1.4.4/js/jquery.swipebox.min.js", function () {
                loadCSS("https://cdn.bootcss.com/jquery.swipebox/1.4.4/css/swipebox.min.css", function () {
                });
                $(".swipebox").swipebox();
            });
            loadScript("https://cdn.bootcss.com/mixitup/2.1.11/jquery.mixitup.min.js", function () {
                $('#galleryul').mixItUp({
                    animation: {
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
                        reverseOut: false
                    },
                    Selector: {
                        target: '.mix'
                    }
                });
            });

            break;
        case "talk":
            $.ajax({
                type: "get",
                url: "Ajax/GetTalk",
                dataType: "json",
                success: function (data) {
                    var histalkct = $("#histalkct");
                    histalkct.fadeOut("fast", function () {
                        histalkct.css("display", "none");
                        if (data.length === 0)
                            histalkct.append("<p>暂无</p>");
                        else
                            for (var i = 0; i < data.length; i++)
                                histalkct.append('<div><img style=\"float:left;margin:5px\" src=\"photo/' +
                                    data[i].UUID + '.jpg\" height=\"40px\" width=\"40px\"/><h4 style=\"float:left;padding-top:10px\">' +
                                    data[i].name + '：</h4><p style=\"clear:both\">' +
                                    data[i].cont + '</p><p style=\"text-align:right;color:#ccc;\">' +
                                    data[i].date + '</p></div><hr>');
                        histalkct.css("opacity", "0");
                        histalkct.slideDown('slow', function () {
                            histalkct.animate({"opacity": "1"}, "slow");
                        });
                    });
                }
            });
            break;
        case "personal":
            $(function () {
                $.ajax({
                    url: 'Ajax/GetInfo',
                    type: 'get',
                    dataType: 'json',
                    success: function (data) {
                        $("#birthday").val(data.birthday.replace("T00:00:00", ""));
                        $("#QQ").val(data.QQ);
                        $("#phone").val(data.phone);
                        $("#mail").val(data.mail);
                        $("#university").val(data.university);
                    }
                });

                $('#passwordform').submit(function (e) {
                    e.preventDefault();
                    var passwordsub = $('#passwordsub');
                    if ($("#passwordn").val() !== $("#passwordr").val()) {
                        Messenger().post({
                            message: "两次键入不一致",
                            type: "error",
                            showCloseButton: true
                        });
                        return;
                    }

                    passwordsub.addClass('disabled');
                    passwordsub.attr('disabled', "true");
                    $.ajax({
                        url: 'Ajax/UpdatePassword',
                        type: 'post',
                        data: {password: $("#passwordn").val()},
                        success: function () {
                            Messenger().post({
                                message: "提交成功",
                                showCloseButton: true
                            });
                            passwordsub.removeClass("disabled");
                            passwordsub.removeAttr("disabled");
                        },
                        error: function () {
                            Messenger().post({
                                message: "提交失败",
                                type: "error",
                                showCloseButton: true
                            });
                            passwordsub.removeClass("disabled");
                            passwordsub.removeAttr("disabled");
                        }
                    });
                });

                $('#infoform').submit(function (e) {
                    e.preventDefault();
                    var infosub = $('#infosub');
                    infosub.addClass('disabled');
                    infosub.attr('disabled', "true");
                    $.ajax({
                        url: 'Ajax/UpdateInfo',
                        type: 'post',
                        data: {
                            birthday: $("#birthday").val(),
                            QQ: $("#QQ").val(),
                            phone: $("#phone").val(),
                            mail: $("#mail").val(),
                            university: $("#university").val()
                        },
                        success: function () {
                            Messenger().post('提交成功');
                            infosub.removeClass('disabled');
                            infosub.removeAttr('disabled');
                        },
                        error: function () {
                            Messenger().post({
                                message: "发生错误",
                                type: 'error',
                                showCloseButton: true
                            });
                            infosub.removeClass('disabled');
                            infosub.removeAttr('disabled');
                        }
                    });
                });
            });
            break;
        case "earth":
            loadScript("we/api.js", function () {
                $("#earth_div").css("height", window.innerHeight);
                var earth = new WE.map('earth_div');

                WE.tileLayer('https://cas.lyzde.com/map/{z}/{x}/{y}.jpg', {
                    tileSize: 256,
                    bounds: [[-85, -180], [85, 180]],
                    minZoom: 0,
                    maxZoom: 16,
                    attribution: 'WebGLEarth',
                    tms: true
                }).addTo(earth);

                var university = new Dictionary();
                university.put("北京大学", {lat: 39.986913, lng: 116.3058739});
                university.put("北京航天航空大学", {lat: 39.982826, lng: 116.353931});
                university.put("北京理工大学", {lat: 39.7174289802915, lng: 116.092143980291});
                university.put("北京师范大学", {lat: 39.9619537, lng: 116.3662615});
                university.put("北京邮电大学", {lat: 39.962796, lng: 116.358103});
                university.put("大连海事大学", {lat: 38.870041, lng: 121.534141});
                university.put("电子科技大学", {lat: 30.675104, lng: 104.100361});
                university.put("东北大学", {lat: 41.7697444, lng: 123.4197519});
                university.put("广东外语外贸大学", {lat: 23.0637099802915, lng: 113.401560980291});
                university.put("湖南大学", {lat: 28.179012, lng: 112.943822});
                university.put("吉林大学", {lat: 43.882562, lng: 125.307669});
                university.put("暨南大学", {lat: 23.128057, lng: 113.347721});
                university.put("加州大学圣地亚哥分校", {lat: 32.8800604, lng: -117.2340135});
                university.put("康奈尔大学", {lat: 46.72112, lng: -118.7838579});
                university.put("兰州大学", {lat: 36.0477699, lng: 103.8585624});
                university.put("密歇根大学", {lat: 43.5912088, lng: -84.7751384});
                university.put("南方医科大学", {lat: 22.790184, lng: 113.228722});
                university.put("清华大学", {lat: 39.9996674, lng: 116.3264439});
                university.put("厦门大学", {lat: 24.4373484, lng: 118.097855});
                university.put("上海交通大学", {lat: 31.202264, lng: 121.435256});
                university.put("深圳大学", {lat: 22.5340033, lng: 113.937192});
                university.put("武汉大学", {lat: 30.5360485, lng: 114.3643219});
                university.put("西安电子科技大学", {lat: 34.235138, lng: 108.9185219});
                university.put("悉尼大学", {lat: -33.888584, lng: 151.1873473});
                university.put("香港大学", {lat: 22.2829989, lng: 114.1370848});
                university.put("香港科技大学", {lat: 22.3363998, lng: 114.2654655});
                university.put("香港中文大学", {lat: 22.4215144, lng: 114.2078426});
                university.put("浙江大学", {lat: 30.263608, lng: 120.1234389});
                university.put("中北大学", {lat: 38.009274, lng: 112.442602});
                university.put("中国科技大学", {lat: 31.8412799, lng: 117.268863});
                university.put("中国人民大学", {lat: 39.966924, lng: 116.321391});
                university.put("中国药科大学", {lat: 31.89791, lng: 118.913745});
                university.put("中山大学", {lat: 23.0963779, lng: 113.2988285});
                university.put("中山大学(珠海)", {lat: 22.341292, lng: 113.589776});

                $.ajax({
                    type: "get",
                    url: "Ajax/GetEarth",
                    dataType: 'json',
                    success: function (data) {
                        for (var i = 0; i < data.length; i++) {
                            var uni = university.get(data[i].university);
                            var marker = WE.marker([uni.lat, uni.lng]).addTo(earth);
                            var student = data[i].student;
                            var popup = "<h5>" + data[i].university + "</h5>";
                            popup += "<ul class=\"list-group\">";
                            for (var j = 0; j < student.length; j++)
                                popup += "<li class=\"list-group-item\"><img alt=\" \" src=\"photo/" + student[j].UUID + ".jpg\">" + student[j].name + "</li> ";
                            popup += "</ul>";
                            marker.bindPopup(popup, {maxWidth: 120, closeButton: true});
                        }
                    }
                });
                earth.setView([22.552947, 114.120626], 4);
            });
            break;
    }
}

function addressBookShowInfo(obj) {
    $.ajax({
        type: "get",
        url: "Ajax/GetAddressbook/" + $(obj).data("id"),
        dataType: 'json',
        success: function (data) {
            $("#crealname").html(data.name);
            $("#cmail").val(data.mail);
            $("#cusername").val(data.username);
            $("#cbirth").val(data.birthday.replace('T00:00:00', ''));
            $("#cphone").val(data.phone);
            $("#cqq").val(data.QQ);
            $('#cinfo').modal('show');
        }
    });
}

var bulletinCurrentNotice;

function bulletinShowNotice(obj) {
    var uuid = $(obj).parent().data('id');
    if (bulletinCurrentNotice !== uuid) {
        bulletinCurrentNotice = uuid;
        var hideid;
        if ($('#defaultb').css("display") === "none") {
            hideid = 'ntb';
        }
        else {
            hideid = 'defaultb';
        }
        var ntb = $('#ntb');
        $('#' + hideid).fadeOut("fast", function () {
            ntb.html('<div style="text-align:center"><img src="data:image/gif;base64,R0lGODlhKAAoAKUAAEyarKza5Nzq9ITG1LTu/HSyxPT6/Jzi9NTu9Nz6/JzK1MTi7JS6xOz2/GyqvITO3LT6/HS6zMz+/Nz+/NTq7Kzq/JTG1NT2/JzS3GyyxIS6xFyitLze7Nzy9IzK1MTy/Pz+/NTy9OT2/MTq9Oz+/JTO3MT+/Gy2xFSerLTW3Nzu9ITK3Lzu/HyuvPT+/KTm9KTO3JS+zOz6/IzS5Lz+/Hy+1NT+/OT+/NTq9KTS3IS6zNTy/OT6/Mzq9Gy2zP///yH/C05FVFNDQVBFMi4wAwEAAAAh+QQJBgA/ACwAAAAAKAAoAAAG/sCfcEgkNhrDWKzIbDqbCt2w1XpanyAESLhAbX/Uq7goyqiELhRFGB67f5jBtwBjV99OkOgriyyEMAVbbXhMMisjXxwRBj8UKEiEhUU7D4k/BjUBIAYbf5KTQ1mIQj0ZDSA6FmB3oSA8Xz87pCAeJT8pDiCgeCQHBCRfs4llKgYCrKFDJCwHHy5Cw1mNdsqiPC8vF1s7M9RTrdY/IBcHFQmcsdWTLhI30EMuHwcJTbxjIBI0EDTuIFsu1IGzBsLFBAkQ+NmAx+TeJBAkJpgg4cShuIrh3tyYwLFjR4FDGDAIFXGjyQk3boC8iGUlS1EFSZBg+FKUCxcpb8x0SZBEKcqdX3gqKxiQyL9/NfMcFcpyadImTp8yOSq1qtWrWLNq3cq1q9ev1oIAACH5BAkGAFYALAAAAAAoACgAhjSClJzG1NTm7Jzm9GSyxOzy9LzW3JzW5ITC1NT2/FyarLzm9KzW5NTy/HyuvOz6/ITO3Lz+/KzO1OT2/HSqvEyOnLzi7Pz6/KTO1Jzi9JTCzNT+/GSitOTu9ESKnKTGzLT6/HS2zMzq9Kzi7Iy6xPT6/Mz2/Mze5DyClOTq7Gy2xKTW5ITK3Nz2/Nzu9JTS5GyirJzK1Nzq7KTm/Oz2/Lza5ITG1GSerMTq9LTa5ISyvOz+/IzS5MT+/LTO1OT+/HyqtFSSpMTe5Pz+/KTe7JTK3Nz+/OTy9KTK1LT+/Mzu9LTe5Iy+zPT+/Mz+/Mzi7DyGnGy2zKTa7Nz6/Nzy9GymtP///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf+gFaCg4SEDzSDGEiDR0eFj5CRggxFg0wkgxSYkpyDQy2DIipDgkxMgkMeNZ2sDyygVkMELqWbAgAPrKwjB6RWCDmlp1YBCrqQQzu+JRBKgksIpBqbHBrHjzsZCb44PCVWVFHfJKc0Hk/Xj1MZJqRDLwtWJSEiVpdWQlDf6YXrJoINWDwYUmSFFXL2qvi6lmyhv1hSiFixEA1JjCEKPvCzsiNJjya+1m1zNaEELUEdUAjYaKWJkyROQrL7tG+Qjwo1+Q350SOJEVJTZjSBBAQIS0JDjESIoAzkowsVJOg0smOop5c/IskAkGLqBicbqA4h5RTShyAXWA5pssOIE7BOPxY+gqHjKNImP4xYfdQEhQG76U6gKLCR7Y7DiA/LJeTjBkvDkKuWBUy5cqGxYy0jw4xZ82XOniNlDk26tOnTqFOrXs26tevXsGPLDh0IACH5BAkGAFsALAAAAAAoACgAhjSClJzCzNTm7Jzi9GyuvOzy9Lzm7FyWpJza7NT2/ITK3Lzy/EySpISyvOz6/LTW3OT2/ESGnNTy/LT6/Mzi5FyitJzK1LTi7HyuvPz6/Nzq7KzW3NT+/Lz+/DyClPT2/MTq9JTW5EyarJTCzPT6/MTa3GyirKzO1NTq7KTm9HSuvOz29MTi7FyetNz2/ITO3Mz2/JS6xLzW3OT+/EyOnMzm7KTO3Kzq/Hy2xKza5DyGlHSmtJzG1Jzm9Lzm9KTe7MTy/FSSpIS6zOz+/OT6/EyKnOTy9Mzi7JzO3HyyxPz+/Nzq9KzW5Nz+/Mz+/FSerPT+/GymtNTq9HSyxOz2/GSerNz6/ITO5Lza5LTu/DyGnP///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf+gFuCg4SEJA6DOUyDVCuFj5CRgj4/gxYWg0KYkpyDSkSDEgpKgkibSk8sg0cknZBDA6BbSgougpeCUiKtWygeKK6QCzekWwg+pZs2U4JKUSrBzUPFUD0JkwikpoJTNoJYHkbRW1ATTcUJKVBbEArrFkhbJE9S8gwj44Iz5qRKKTDkrtjCVeNJKx4MPuTTZ06QlR4OlPy4sAWXBRxKqOh4EE0JlGJb9jWZlWXBFhAhlChSQoBjkiogO0Fx0uQjw3OwiGSAQEgKiSMABOSD0sTJjHUh+RFBWijDAQwLZw3h4GRa0piFTugoEFWaEw4flWBlVCTAOCVDbHqaUZVTDBpWvIKhHTJjRlqx5MYO0uBBRlSxUOjaVQtJyQ4TGbp6msv0UQkPQhWPyxCkwV+xmDNLohCB68LMoPV6kky6tOnTqFOrXs26tevXsGPLnk27tu3buHPnDgQAIfkECQYASgAsAAAAACgAKACGNH6UpM7c1ObsnOb0ZKa0tNLc7PL0vObshL7MnOL01Pb8vP78TJqspNbkZLLEtNrk7Pr8xPL8tPr8jMbU5Pr83O70zObsdLLE/P78PIaUrMrUrOr8jL7M1P78zPb8VJqsrNLcxN7k9Pr8PIKUtNbchMLMrN7kbLbEvN7k5PL0zOrsrM7UVJ6srNbcNIKU1Or0nOb8ZKq87Pb8vOb03Pr8xP787P78zPL8tP78lMrc5P783PL0fLbEtO783P78zP789P78tNbkhMLUrN7sbLbMvN7szOr0rM7cVJ60rNbk////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/6ASoKDhIRAQIMzB4MQMoWPkJGCET2DJkODOS2SnIQYNoM0AxiCQyaCGEQqgxaknY9AEqBKGAkUpadKFQ4ighUMKa+QPzWuGx64gg9CqBccwqhArkA4OoIeG6QPmEoTuSgfjrQvrpFAPzquPguIFDCIpkoiJxXyBEeoJCMCnTY/NqQwLOhAC8ateC+I9ApAoBeGICNAlJPkz5oSHRKk9Yig5JKSADkwpEASQlAQFysmesJQzh8oDDV+KFGQTREGISiUIOBB6mRKSRh0AHRVEUMsG0AgENohosKHChhIuCjw6pNQov8+IYIkQgWGAi5AQDNqQ4c0Jf5UPsKgIcMRtVicjAqVxrKThhEa4Baq66nsVk4rAOQVxrJwOb6R2AqGttKwXlR3NTCGZBho5MeTOV3OzNmAYMycJRkITbq06dOoU6tezbq169ewY8ueTbu27du4c+veTSgQACH5BAkGAFkALAAAAAAoACgAhjSClJzCzNTi5GyyxLTi7NTy/Ozy9FyWpJzW5LT6/ITK3LTW3EySpNT+/ISyvOz6/MTm7MTa3ESKnHS6zOTy9MTy/NTq7FymtLTe5Pz6/HyuvKza5JTW5EyarGyirDyClJzO3Lzq9Nzy9KTe7ITO3LzW3PT6/MTq9MT+/Nzq7Gy2xOz29KTa7Lz+/LTa5OT+/EyKnOT2/GSirFSarDyGlNz2/JzG1NTm7Lzm9Jza7LT+/IzG1LTW5FSSpNz+/JS6xOz+/Mzi5MTe5Hy+zOTy/Mzy/NTu9Lze5Pz+/HyyvHSmtKzK1Lzu/Nzy/ITO5PT+/Mzq7Mz+/Nzu9Gy2zOz2/EyOnGSitFSerDyGnP///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf+gFmCg4SET0+DRRWDJg+Fj5CRgg1Rg0whgyM4kpyESIiCLwlIgpeCSE4Fg0aknY9PUaBIOkCCIZhZMQqgIgMxrpA+Da0oDaVMgjgIpzsgwKdIrUhRtVkNKKSmWTmbWRBTjllIUqCRSC9PrUBRpEA6iKZPCr8mEy6nPDMinU/opEgNXojTIbACpiZOSG0YgggJjytHWnHqB2pduiiVbmUhwAIJFRVQBOWLKEliForifPjI4qMFEkVIOJzIAmIHKRcdSIqTYsJTNIkUP8VCUk1QjCcUBjRx2EHIICJJADgt9HNQ0HSRTLAaKciEDRpWbpirevKFyUhULkR0yIDBggxgnX7KdYXEBBILVrAE6PmMLDADDgBooPCsMCETAT4cCGK4MZISPWAsgdu48A0PH34YqFwY8AcPKTgXziChR4SzojsJoJy6tevXsGPLnk27tu3buHPr3s27t+/fwIML/x0IACH5BAkGAFwALAAAAAAoACgAhjSClJzGzNTm7GSyxJzm9Ozy9FyWpLzW3NT2/ITK3Lzm9Jza5HSqvFSSpNTy9Mz6/GSitHy2xOz6/OT2/MTy/ESKnKzO1Lzi7ITO3Jzi9Pz6/OTq7NT+/Mzm7OTu9GyqvDyKnKTGzNzq7HS6zGyerEyarGyirIy6xPT6/Mze5DyClNTq7HSuvKzq/FyerNz2/JTCzMTm7KzW3Nzu9IS6zOT+/Mzu9MTe5JTS5Kze7FSarJzK1GyyxOz2/Lza5Jza7HyqtMz+/GSmtISyvOz+/OT6/EyOnLTO1IzS5Pz+/Nz+/Mzq9OTy9KTK1GymtPT+/DyGnNTq9LTu/FyetNz6/JTG1MTq9Nzy9Mzy/MTi7Kzi7FSerP///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf+gFyCg4SESU+DHByDT4iFj5CRXDVKg0EPg1IUkpyGSYNEQZ9cD5hcSQQvgy+jnYVJNaNJQY6XgkUZoxMJRa6QRESjHDWCpYJYLYJJPzm+kLCONRyftlyagjYYKMpXrZFJrU+xXE+ipJhPGb1JSDHKFzwTneCywKe0XLZFBJ8KOIhJ4MXw9g2cIHHglBAzRkFKEgkYHAgSSFASvVP2pCVRlKSFxBw/PlFUNmMbp4uwwDm6lWTXhIA8OgxiQkNHFFcXn1Q82E2gIBQ7tkS44sygKxQjBibxMWXAjZ3OLKJIEoXFFhkaomodlKVElR6EUPg44WFrJxRMTqHoAMMFgApVDNKalYRCRIgPFVRACCDA5NxXGywAMQKgwYkbYP8+KnBgSAMARoAc2QBVMQkVKkyEEOFXsaQjKSp7Hk26tOnTqFOrXs26tevXsGPLnk27tu3buCUFAgAh+QQJBgBCACwAAAAAKAAoAIZMlqys0tzc7vSEwtSs6vzE7vR8rrz0+vyc4vTc+vzM9vycytSUusRkssTE4uTU7vR0uszs9vyEzty0+vzs+vzc9vzM8vxUnqyUwszM6uyEtsSk6vzk+vzU5uys2uTk8vS87vx0tsz8/vyk5vTU/vyk0txsrrzM5uyEvsy8/vxcorTM7vTc8vSEyty06vz0/vyc5vTc/vzE/vycztTE4uzU8vR8vtSM0uS0/vzs/vzk9vxUnrSUytzM6vTk/vy83ux8tsRsssT///8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH/oBCgoOEhCIigz4+gy8vhY+QkYI5OYMxMYMkJJKchYiCIj6fl6A4i4Icn52Ph6A+jkI+mEI5E58+CJWrrKo5sKRCJCmgBCC7ka1CL6fAMptCCTCwIjqqu8mhiKQiOJUiIxagKy0cx4OtoY6ysTiIBRuIIuMr1tfxlEKkmiI5MAmC8+oda/UiRyhRKTCBcIEoIKgPsOwdsmYQl8ECLVYMisCjAQtzQgSeSzVP0AEPQVpEALnrwA16ImhAsNFDJEtWL0QIGADhx4GbIHs0KEGB0AEHC1YCjfRipYgDGRaYAKACxc+lkQ4EALJDBZAAD2xiFXTCxIITSseuEruUgYG3LHDjajCgAcjcuhjaxt3LFy4DtYADCx5MuLDhw4gTK17MuLHjx5AjS55MWW0gACH5BAkGAFUALAAAAAAoACgAhjSClJzK1NTm7GSyxJzm9Ozy9LzW3ITC1NT2/JzW5FyarLzm9NTu9ISyvITO3KzW3Oz6/Lz+/EyOnOT2/KzO1HyqtPz6/ESKnHyuvJTCzNT+/GSmtMzq7OTu9LTe5DyKnOTq7LT6/Jzi9IS6zJTO3PT6/DyClKTO3Nzq7Mze5ITK3Nz2/MTm7Nzy9Kza5Mz+/LTO1HS2zGyirKTGzNTq9Gy2xKTm/PT2/IzG1KTa7GSerNTy/Iy2xIzS5KzW5Oz+/MT+/FSSpOT+/Pz+/HyyxJTG1Nz+/Mzu9OTy9LTi7LT+/KTe7JS+xJTS5PT+/DyGnMzi5Nz6/MTq9LTS1GyitP///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf+gFWCg4SFhE4/g0NOho2OjUNDgz+JgkZCj5mPkZOVQy+VVT+SmqWcopVOL6Q/SoylmqeUgkIagkNAL7CmrJWXtK63o7uGsomfjE4RRrcIIqHEipKzqpIaEZJDCAQrpNHSqFW1i0qYVc5R3t+3kohDGokvQJLbCKRDE+rE6k5DPyGj0A2CsETFinWOhgjRJgKBICcLVOSYgDCTExvphhzp0WSHvoqFFg1ZkcCBlFcgNe1QkaTEIQ4+XKYMCaHKkBIMXBwYUIOEzJmESnjAUaMGDg8tLABtxOCADwY/lyaUOmhKCqUhi4zYynVrgIo6TJiQMQMF1ionAqhdq/YByAJKBhoEASChAowOH6laAEGhwgUACjKwqEnVUAkUGahceLIhAI28UofcgMJEAYALRJAUdnTDAI8Om0OLHk26tOnTqFOrXs26teuKgQAAIfkECQYAYAAsAAAAACgAKACGNIKUnMLM1OLkdK68nOL01PL07PL0XJakpNLcvOLsfMrc1P78tNLcTJKk7Pr8xPL8lLrE5PL0ZKa0RIqctPr8nNrs1OrshLK8tOLsjM7ktN7k/Pr8dKa0dLbE3PL0zOLs5Pr8VJqsbKq8PIKUrMrU9Pb8xOr09Pr8vP78bKKsrNrk5O70xNrcnMrUfK68pOb07Pb0rNbcxOLkhM7c3Pr8VJKk5Pb0TIqc3OrsrOr8lNbkvNrk3Pb8PIaUnMbU1ObsnOb01Pb8ZJ6svOb0vNbcTJak7P78zPb8jMLMZKa8pNrs1Or0lM7c/P78fLbE3PL85P78VJ6s9P78zP78bKa0rN7sfLLE7Pb8rNbkhM7k3P785Pb8TI6ctO78vN7kPIac////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/6AYIKDhIWETU2DiIaMjY6KiYJGRo+VlotgTVBSg1KRlqCZkZqRUlOcoaCYUlCCTQtaqaGYRqhGU6NGn7KFi5qcTVOtmVAUqLy9iayJUAuJTVoUw8jJYFK6wZRg0VC71K6Im9vOYMXTTQ7e1IimntGxkl0E09+KutyCUkcEXdr1hk1QdHv14gUPdf9ceYKS48URhAkJ0eC3gZCUAhhORDwETAqPIToUZKhybKM1E0qyzKhgYgvEhE90YHii0aSjl98EVASIgInPnz6xUDsxoQYLdRqwIMASY2nTBN8MXBjBAcchnPUECOkBwYCgD0mQeImAlVcTIlxukGhywguSJE8hRLSQUXNjiQA9Dnxw5SGGkxAhOlyxacAFACs2Di2JUdfkDyFffDS2WWgDgwY1NJSNeHeEhCWUHa0YMEJGaEc4Spxezbq169ewY8uezSsQACH5BAkGAEsALAAAAAAoACgAhjR+lJzO1NTm7Jzm9GyyxOzy9Lzm9LTS3JTi9NT+/HzC1Lz+/EyarKzW3KzK1LT6/Hy2xOz6/Lzu/LTi7OT2/GSmtNzu9Kzq/Pz+/DyGlHS6zMzm7Lza5IzCzMz2/FSarKzS3PT6/LTu/DyClJzS3NTq7HSyxMTm7LTW3Nz6/KTe7KzO1Hy+zMzy/MTi7OT+/LTm7IzK1FSerDSClJzO3Gy2xOz2/MT+/KzW5LT+/Oz+/MTy/Lze7OT6/GyqvOTy9IzG1Mz+/PT+/NTq9MTq9LTW5Nz+/KzO3IS+zLTq/FSetP///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf+gEuCg4SFhoeIiYqJGBiLj5CCjYOTkZaSjpIvmZeRlRg6Op2XlUKbkkKco4eTGC9CkjpBsKusmaaOoEGitbZLrrSyOqq9lI6hx7uUw8WSv5u6vEtCQTnSzRipwoJCCTk3182Syq45C6fihY2gNzlGxOmELzmzhBgpO7Tx2b8YPTsXEAyQoC+eEA9JBgwQ4SECvHQ9LuzoUTCeoYfFCiDCMEGFx48eDaz6AcDBQwM8YPAwMGHlBCK1HIwwqQ5jLwwyaQ4awoLECRs2O+EsSUiICxoaCCjAUaLiqqEOBIUoIYkCDyA1CACJIM7BjKgbGCD5YW8ID6ercmKwAEEGjRBIFu05yACikQsfFYoErYVhRYYiUkEoMVFi7ygMR0agGBShw4cNcQeBGNGAE9DIg/weMCwOcQYUnLElpor5ogC4pVOrXs269aBAACH5BAkGAFwALAAAAAAoACgAhjSClJzCzNTm7GSyxKzi7Ozy9FyWpITG1JzS3LT6/NT2/LTW3EySpISyvNTu9HS6zMTm7Oz6/MTa3ESKnHSuvIzS5MTy/FyitOT2/Lze5MTq9Pz6/JTO3Jza7EyarOTy9GyirDyClNzq7GyyxITO3NT+/LzW3Nzu9PT6/MT+/Kza5KzK1Lzu/Oz29IzK1Lz+/LTa5Mzi5EyKnHyuvGSirMzq9FSarDyGlGy2xNzy9JzGzNTq7LTi7ITK3LT+/Nz2/LTW5FSSpJS6xHy+zOz+/MTe5JTW5Mz2/OT+/Lze7Pz+/KTa7HSmtNzq9Nz+/PT+/Mz+/Kze7Oz2/Mzi7EyOnHyyvGSitMzu9FSerDyGnGy2zNzy/P///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf+gFyCg4SFhoeIiYqLjI2OhEqPkodKkZOXgpWYl5qZnZuKnUpPSJagiKKkT6ehlqqmrIWdqoOjsKyVo0irmU5QvLFclbTCSFAlwMHFq0pEx0S3wblPJVDQyojOpYSkJdGno8LNJS8+Pr/YvSk+CSlO1+mCRC8lRMnxtfEbqBYs/v/+LGCKMaEAoiMW+iVkkfAIpg1BGlD6dkpCCAGGtlQg4CACxUlKmIDYx81BlAo9jPDYcu+SiBAmCKE4kQmDhiUkenRAcUoIFZ6CdgzggAHSDw0tJRWQEUCYFCUfOIxQARTbihsFWlwAUqnGkAcQPl7aYGCGkgw2gAhCkQTHgRNNYiVNCbHjrAcYg6QgGOEAWxUr+zJ44DrII7YPIdRyKZI2LqgADHiexUIYHwoGOjKhzYFP0IIsH2o63qQEBIXRsQQAaNL5UJGqrWODCgQAIfkECQYAYAAsAAAAACgAKACGNIKUnMbM1ObsZLLEnOb07PL0XJakvNbc1Pb8vOb0hMrcnNrk1PL8dKq8zPb8VJKkhLK8ZKK0vO787Pr85Pb8rM7UvOLsRIqc5O70/Pr85OrsdLK81P78zObsrOLsjMLMZKq8zN7kPIqcpM7U3OrsrOr8XJ6slNLknOL03O70TJqsbKKszO709Pr8xN7kPIKUpMbM1OrsbLLE3Pb8xObsjNLkpNrshLrMxPL85P78tM7UZJ6s3PL0VJqsxOLkpOb87Pb8vNrkhM7cfKq0zP78ZKa0vPL87P785Pr8rNLcTI6c5PL0/P78fLbE3P78zOrslMLMtO78XJ60bKa09P78PIacpMrU1Or0bLbM3Pr8xOr0pN7sjLrE3PL8VJ6sxOLs////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/6AYIKDhIWGh4iJiouMjY6PkJGSk5SVgkyWkEyYmY2bnJ2Kn6GLo5ebpISmYExHOaCkpkxUOUewoaOztVS3qZuuvKmHtLaqrr2WqJu0HERETsjJOU7OHDnBwoJU1sXZhtHeTM3O5NWTOjuJHM3sRM1OkyEvBYeoqRkvB4dIP0Yz2JlWQKiHQMIPFD9wIKFiCcaDWy0oXDqCIAoKFFEYTiIBQEMhBgq2TFCFxAG4RRmUVBjEBAiTCTaEJGiRakiDQS02WNjE4EQNFicf6VDSokUQJjRkWNCmRcECiZkwABCQoscVJh0GLNXmQcGMTEwMWAHzYQOmrDsHTQjaiMuUlkxeggjqoJQtJBdVaCYpMhJp3VRALnQA06LIiEt0oZLaAUXQlx5LLiGx+yiAiUtNblCWJAAATTBVeXgT1OKCXEEpNI5uwGX0oSUYHAUCACH5BAkGAEMALAAAAAAoACgAhkyWrKzS3Nzu9ITG1Kzq/MTq9HSuvPT6/Mz2/Nz6/Jzi9GSyxJTO3NTu9Iy+zMTe5Oz2/LT6/MTy/Oz6/OT2/ITO3Mzq7HS6zNT2/FSerOTy9OT6/KTq/Gy2xKza5IzK1Lzy/Hy2xPz+/MT+/KTm9GyuvJzS3MTm7Lz+/Mzu9FyetNzy9ITK3LTu/MTu9HyuvPT+/Nz+/Jzm9JzK1NTy9JS6xLT+/Oz+/ITO5Mzq9Hy+zNT+/OTy/OT+/LTe7Mz+/GyyxMzm7FyitP///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf+gEOCg4SFhoeIiYqLjI2Oj5CRkpOUlZaXmJmam5IinIkioZ6fhaKjpIKmqIOqq6mhpTAwp5yiNzc9PTe0mSIwuLqzvJq/u8Okx6giPTHNzs09kzU1iczMMde5ky8viLCb3Ig3KD89s5jhh8s/NjYoOz3JjemlG6kwMSM2ESMw292GNiho4Y/VjRjyFNFLdUDEjRYKJCR8tHDIARw5QiUgQALDREb0DlgQ0YCFi1QIFBCwV4mbiAcQNCxYISIFixSDYIBQwPKfCAMBhphw4ImGyVPnKIWbEULEhA4nBJV08XFetyAZDgzxoUMrSYxVF4U7oCLIEBE6PKRKgaNnS4A0IWYICtIBQqoJYRUCDFAi1QcGea0KEgBA6xAeQHhwSidCyINBNBcDHOJA7qoaDgYdMMwoEAAh+QQJBgBTACwAAAAAKAAoAIY0gpScxszU5uyc5vRkssTs8vS81tzU9vxclqSc1uSEyty85vTU7vSs1uSEsrzs+vx0qry8/vxMjpysztTk9vxkorSEztzk7vT8+vxEipzM5uys4uyEwtQ8ipycztzk6uzM3uTU/vyc4vTc8vT0+vw8gpSkxszc6uy0+vx0uszE3uRcnqyMxtTU8vS01tzM/vxsoqyU0uTM7vSUwszU6uxstsTs9vy82uTc+vyk2uzE6vSs2uSMusTs/vx8qrTE/vxUkqS0ztTk/vyM0uTk8vT8/vzM6uy03uSMvszc/vyk3uz0/vw8hpykytS0/vxknqyMytTU8vxsprT///8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH/oBTgoOEhYaHiImKi4yNjo+QkZKTlJWWl5iZmpucnZ6foKGigkVFoqWopp6pqKCpo7CFRT20tbVLk09BiUs9vb60vZIFJSCIpZsGJRiIPSFJvqqVDjCJs0khLyFCPdKQRUAmxz2kS0JJL9rejR8AJ4hCKC+4g0Xm64wTEsyyS7M/KELgi+TDx6ElAw6UEhIhQpKBjUhI2EWIhIwiOEQcIJXEyQ9ykgQA+GCviBEbFBRQwKhx0JIXKEBCaoKgyIwZRTgcmbIhgamMCl1CtCaFxxQkSKY0YFGEhAUZgoAOZUQig4opPJIyqEFiio4hXVkGnaSBiY0pM4ySSEFjypIYUQtIZZQZacYTQUgFsdghiIGFB6S6UVoRQFBWQTc4kMqhZGpEAAIMJ50ygkDXKRQsULh0I8PltKRSaBi08hIPCIMOC/LQgNMFIoNcuBhEgh6jQAAh+QQJBgBZACwAAAAAKAAoAIY0gpScwszU5uyc4vRsrrzs8vRclqS84uzU9vyc1uR8ytxMkqS88vy00tzs/vzU7vS0+vyEsrzk9vxEipxcorSs6vy87vycytR8rrzU/vyk2uyMzuS02uT8+vzk7vRsoqw8gpSk6vz09vzM4uRUnqzM/vzc7vTc6uyk5vTs9vTc9vys0tyEztxUkqTM8vz0+vyMvszk/vxMipxkoqysztR8tsTE2uQ8hpScxtTU6vSc5vR0rrxcnrS85vSk0txMlqy81tzU8vS0/vzk+vy07vzE6vScztx8srzc/vys3uyU1uT8/vx0prTM5uzc8vzs9vzc+vyEzuTM9vz0/vyUusRMjpxkorTE3uQ8hpz///8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH/oBZgoOEhYaHiImKi4yNjo+QkZKTlJWWl5iZmpucnZ6foKGio6SlpqYdikurrK2SBRMjia20S5IRLamHq5oCIDazMQ5TvJRLH0y2iEtTDjHCw8qQQCAns1OCq83PDtKMIlVUig4lSNiD2t6LATIpy8RTSCUx6o8FIDSzQkirDhkl3SQdMaCr0BQoS2LsyxajRIZzjnIAEJDiSqsgLxwMGJIQAhJ08iAuWmIFQ5YVBJb48LFESZEsFirYiuFRWjFGHG54WFLjQpYLPnskYKZDhSCF/CK9WBAgywsSTbIYMZLFSRRbUlCco5n0EY4FIrI04eHgJ9UpG5xkWRLCBUMhXCIXSbjRQNCFGnapZknQQxCUARCJOVpyxIoyAivs+sxSREk2IhbqMTIxUZCDBSYEGVksQcE5jWUjiQAm6AoFZRf0LtnwYBC9SxdgDNo8KEnfTS9eDDpwYJDgRoEAACH5BAkGAEMALAAAAAAoACgAhjR+lJzK1NTm7Jzm9GSyxOzy9MTq9LTW5EyarNT+/JTi9Lz+/ITC1KzW3LT6/Oz6/Lzu/GyqvNTu9Kzq/HS6zLTe5OT6/Pz+/DyGlKzK1Mzm7FyitMz2/JTG1Kze5PT6/DyClFSarNz6/IzK1OTy9LTq/Hy2xMTi7Mzq7DSClJzO3NTq7KTm9Gy2xOz2/LTa5MT+/IzG1KzW5LT+/Oz+/MTy/HSuvNzy9LTi7OT+/KzO1Mz+/Kze7PT+/FSerNz+/LTu/Hy6zMzq9P///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf+gEOCg4SFhoeIiYqLjI2Oj5CRkpOUlZaXmJmam5ydnp+goaKjpKWmpgWlFxkAqaKrIAGjsBkXiRe4tpUZILWLucCRrL63PYTAuowZKRmMFzk0yYK4zjq9v7k5OT3SzgcYxLc7Obg92tyOLyk6FwcuiM8XNDs00+Y0xovq7CsIJA8agInoQWNGvXn1ptEgd2vfkAs2Ogx5weACDhwXJnAYsgOGLYTJqB1qB0KHoBcbXFyI4WEIDx5DhAC50GNGDkHzGCq68AIDuyEfNjQA2kKCy5YWBtj6MUMXSEUrSuoKEOHDEAk2jPFo2WOAhYcLEijckQ/RBwG6SIQ4IchDDEFQLwWVqCEoh4Oy6BpdCGJCF4MKJ2EO4TBhGowdk9SSEPSBwA24LYc8UJCvh4OEkC48FqSBgq6t01iIGBTtkgwVg0ALgkB3Uw+rgoQYGCSSUSAAIfkECQYAWgAsAAAAACgAKACGNIKUnMLM1OLkbLLEvOb01PL0XJak7PL0fMrcnNbkTJaktPr8tNLchLK87Pr81P78RIqc1OrsvOr0jM7kdLrM5PL0bKKspNrsvN7k/Pr85O70VJqsxP783OrsPIKUfK683PL89Pb8rNbchMLU9Pr8TIqcxOr0lNbkdKq0xNrcrMrUxOLk7Pb0hM7cvP785P781O70lMrUdKa0VJ6sPIaUTI6cnMrU1ObsdLbM1Pb8ZJ6spNLkVJKktP78vNbclLrE7P783P781Or0vO78fL7U5Pb8bKa0rN7svN7s/P78zP783O70fLbE3Pb8rNbklL7M9P78xO78xN7kxOLs7Pb8hM7klMrcVJ60PIacTI6k////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/6AWoKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqbnJ2en6ChoqOkpaalGQKkSSk8EBmiHTIeDQehLD8eOjehGSolNT6woBEGNAEhjkmRSUVMAB+2yknUjiQ2EDoCSRXLi9TL4N8YClkMGUlOVyyMSS9Q4eKHMEZYT8laIhsrSVMOiEmAJIHybhA4b4OkeEChYZC+KVpgDChCosDBd1CUQNFCcKPBaoNIdDD4UEuGETu0SEiQJMqQJByCaAnyYFlHhIrSbZAiCAkFB0kuENAyZIiWBxyoKQEi6OY3JxsgaiFBAQPHFiBUGgXSY9mLmk3f4TRUYZ83J0SWgWixUYIELWJJFjBNouSFoIEvxhZKQmVQkQERBBFIIKioIA4PBAFRghBkOysxvJ0wIUiC0Zku7gaRKelvkaYIPhN9qwXIAo8ZPUJqNgjGBG9DSCdxYbep3kgEjgxyO0hJ4k3wBuXI8dFRIAAh+QQJBgBcACwAAAAAKAAoAIY0gpScytTU5uxstsSc5vTs8vRknqzE5uzc9vy81tyEztxUmqzM9vyc1uR8qrTc7vSEuszs+vy87vxMjpzk9vys6vxsrry01uSEytz8+vxEipzk6uzM5uy83uyU4vQ8ipysztTc6uxkprTU/vyU1uRcorR8ssTk7vT0+vy07vzM3uQ8gpTU6ux8usT09vxsoqyMzuRcmqzM/vyk3uyUvsTM7vTk/vy05vS03uyUwszM6uykxsxstsyk5vTs9vzE6vTc+vxUnqzM+vyk2ux8rrzc8vyMtsTs/vzE8vxUkqTk+vxsssT8/vy84uy0ztTc/vyEsrzk8vT0/vzM4uQ8hpzU6vRsorSM0uS06vy04uyUxtTM6vT///8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH/oBcgoOEhYaHiImKi4yNjo+QkZKTlJWWl5iZmpucnZ6foKGio6SlpqQZKk6hGSE7LysrBp1MJ05EEwBJUAkFmxEcOQsAEw4gIRmaTFUBIhpUVjsCLpxRJhoAMTQqLkxcAj6cJ0YX1IJMDy0LB6I+AUEQUUw+3oz1jkwXJRYcTEw4A1A08jeQg4USFwRy6bBEB5MtCg0xkcLF371EVRZoCSeoyZIfXBBgiCAFiEUuR/zZoHhSEZMIg5gw1FGxQRYuDCowGSFjpw2UKSsSHNhhADsuNRSgYIIFCRchQrjYeKKSotCLiGQO4CBICgyQUggoeRpVSk8uUmzUa5mIwtZ6WjdIeFNCgCLUijJYroyJVSJMQREwFBGEBIsgGVG5PPmJVu0kJjOG1KvAQNBdqSPOHTkyKfBfKR7+Iu56tqLjSC8HIehR7/JOzl37RkIiYdBoQYs5DVX8hK+jQAAh+QQJBgA9ACwAAAAAKAAoAIVUmqys1tzc8vSEwtS07vx8rrz0+vyk1uTU7vTc+vxsssSUwszM4uyEyty0+vzM/vzs+vxkprTs9vyUusSs6vzk8vR8tsSc4vTU9vzk+vx0uszU6uyMytzE/vz8/vzU8vR0tsSUytyEzty8/vxsqrzk9vyk5vRUnqy83uSMwszE8vx8srz0/vzc/vzE6vS0/vzU/vzs/vxkpry84uzk8vyEtsSc5vTk/vzU6vTU8vx0tsycytSEzuT///8AAAAAAAAG/sCecEgsGo/IpHLJbDqf0Kh0Sq1ar9isdsvter/gsHhMLpuni9pKzV4X3nD4hDqJ2+/yrscj9tBQKREMXwYMOyQAESkoBl0SIAAnFgECjT0IEFwGATgsQ34hCi5iBgcKISUeEHx6MzoDG3suHJ5bHggDOjOWLjwfHhi1R6xOAgoHmUIuDR89GRcxLDd7fCx8e08elj0eyzncFCo9LSMeNy0e0dzEUN0N3z0YNtYdMOM3PTEx1+xN3b5CWJjAwO1FjHEtuE1bFwXCO1YqKPC54YBPi4TmamHLJgzChQRCYHQQclGIOoZTPBAgwKpDQoQBDwrZGCUGtJkOZJZUSKyfHZN0Q268YHVu5g1hPqXAeDBkZz6ZWmjGwDcz6ZEgACH5BAkGAFkALAAAAAAoACgAhjSClJzCzNTq9GyyxJzi9Ozy9LzW3ITK3FyitNT2/JzS3MTm7ISyvOz6/Lz+/EyOnKzO1OTq7IzS5HSmtOT2/JzK1JTG1KzW5Pz6/ESGnNTy/Hy+zLT6/ITO3GyqvNT+/Mzq7Iy+zMze5GyerKTa7PT6/Mz2/KTO3DyClNzq7HS6zLTi7Oz29Lze7IzG1Nz2/IS6zFSWpOTy9JzO1Mzu9KTGzGy2xJzm9MTa5GSerKTS3Mzi5Iy2xOz+/MT+/FSSpLTO1OTu9JTW5HyqtOT+/LTa5Pz+/ESKnNzy/HzC1LT+/IzO5Nz+/Mzq9IzCzGyirKTe7PT+/Mz+/DyGlNzu9Oz2/IzK1Nz6/JzO3P///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf+gFmCg4SFhoeIiYqLjI2Oj5CRkpOUlZaXmJmam5ydnp+goDIhOFGhg0ETUwAIFiBRRqFGOwE5GUceJyklpwUGPDEAD0MQEbGgGEFAQw8APwwGBZUzMNXW1U7HJSk1IygoOZRFFeTl5CfHhBgiQJ1G6Z9GVQsKGwKfUQIkMDYqWAu8ODVwMWCAlRYUjiFpwCnKCirpjDQgcUDDqRIrOpBICMuTERoShCB5l+CGqU1GkAjp0ORkAgJXjDA5iYnCgRU0X17J0kMJrB5Z3gWdZISmERMwgzqQkoXIh6JAhVYyUvKFICY+ZRLhGRVeJKo3rGaJ4oBJUCmmenSt1CPsoA8+DmJFkRJLrSCpkooOiqJka9MPguwG9UrUh49jH/wKxluJ70kjaAMDHYxJb2C6kgcxxkTEbOa7hC3hjUITUiAAIfkECQYAXQAsAAAAACgAKACGNIKUnMLM1OLkdK68nOL01Pb87PL0XJaknNLcxOLkhMrctNLcTJak1P787Pr8RIqc1OrslLrEtPr8XKK0nNrsxPL8hL7MrOLsjNLktNrk/Pr85O70hLK85PL0xOr05Pr83OrsbKKsPIKUrMrUfLbE9Pb8lMbUTJqs9Pr8TIqcrNrkrOr8xNrcpMrUfK683PL87Pb0rNLczOLk3Pr81O70ZKa0PIaUTI6cnMbU1ObspOb0ZJ6sxObshM7cvNbcVJKk7P781Or0jMLMtP78pNrszP78tOLslNbktN7k/P785Pb8zO705P783O70dKa0lM7cVJqs9P78rN7stO78xN7kfLK83Pb87Pb8rNbk3P78ZKa8PIacTI6k////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/6AXYKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqLKE1Jm4pUIiRKn6CHOTs2OFGnh0kLXAw+pq6EJQFbNTSnV0IZSoQbLgAcHZsoJjUMWiZUV58yBzYBJZtJHRkWE1ADOA4aIyk3PhqnKDQxJBCCVxEiIQK2hiAhIhwGlCpP/P38CLUEJWHx44E5SQmIxMCCAAtDLBkCDtIgD1QSiaeSOKBxAcMLW1FeGDmiAIOUJRgvRaGgoAcRDx9MfWi1KYoHK7WSAJlCYMY8QVEqEJgSJUlRV0kK6FgRM0mWITQ1JfmwgkABmk+Z6Ew5iQmBClGzSGDSJUqRolErGR3kdAjZJE8NspQFcpFrJKdjBQEpchEIkC4XMbUlC7jIWyatAqvMK4hJg09JtAK2+0hx2SJ/5wqkLMlpFlOIN4MySzOyKcuZ1gKVPPlnlMyt51lG/SgQACH5BAkGAEoALAAAAAAoACgAhjR+lJzK1NTm7Jzm9Ozy9GSyxLzm9LTW3NT2/ITC1Lz+/Jzi9Hy2xLzu/OT2/EyarLT6/Oz6/NTu9LTe5KzK1Kzq/NT+/Pz+/DyGlHS6zMzm7JTO3Mz2/Kza5Hy+zMzu9PT6/OTy9DyClKTS3GyuvLTa5Nz2/JTG1MTy/OT+/FyitNzu9MTi7LTu/DSClJzO3NTq9KTm/Oz2/Lzq9LTW5IzG1MT+/KTe7Hy6zLzy/OT6/FSarLT+/Oz+/Lze5KzO1LTm7Nz+/Mzq7Mz+/Kzi7IS+zPT+/GyyxNz6/Nzy9P///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf+gEqCg4SFhoeIiYqLjI2Oj5CRkpOPIBIXlJECIjSYmY4XPxidn6A/IiWliSAwnqEuqaqGKzsMK56nJZ6ygyFFOycygqcdu7xKFxokKgdGoSIUxscXNCokGhcU0LIRLywRhDIBDz7ZABSqICMZBR4jQhGYBCCCFOfSkxcyBhsZRwkd6A3SFu0YiCQlaiQhlM1FwWOIsm2bZOCGxYsWieAzR2DSByAGDIAUGRKfoI4QL5icZsREjhg6IA4yogNFhQUDGphYmclIC5wtOPTw1MMIRCMcdOy6YMQGjxQyCxmxwMOGM5VRLwRRoGDohR5DeObrwTWIpxRDhjrj1YNH2EE+aHsgS4FJLKilcZH1kIt1Gli5SozQRWYX0oW8c40SPmYk7czBfXlFPqw4ssyvQwVZTjlYc2FKkz/L2hxVZiAAIfkECQYAWgAsAAAAACgAKACGNIKUnMLM1ObsbLLEtOLs7PL0XJaktPr81Pb8fMLUnNbkTJakxOLktNLc7Pr81O70RIacjM7khLK8xPL8xOr0XKa05Pb0rNbc/Pr85O70dLrMlMLMzOLkvNrkPIKUvO789Pb8pN7sTJqs9Pr83PL0TI6cxP78bKKsnMrU3OrsfK68vOLs7Pb0vP781P78hMrcpNbkxObslM7c5P78xNrkPIaUdKa01Or0dK68ZJ6stP78hMLUVJKkxOLsvNbc7P781PL0TIqcjNLklLrEzPb8zO705Pb8rN7s/P785PL0fLbEjMrUzOLsVJ6s9P783PL8TI6kzP78bKa0rM7UvOb07Pb83P78pNrsxN7kPIac////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB/6AWoKDhIWGh4iJiouMiyNMjZGLNx43kpeHOFJImJJIN5xaGR4dnZFJTRehGzwjpo1YqZwgJSivjEixF4INWRa3hk4koVpYIrtIOUrAhU8DS0mhPakYAgACzIRVMgMwDoK6GCoGGNmDnzsaK+VYFVUFHlPmhE4rGgmgI5wBQSzATkeKfBs0AsaAGINoDflHQMgLIQSA6NPiwNUgHx5SMEPioEiICC8UULF47oQNYsycGKGiwIghazTmMZLAo1ynCR9y6tSJclABCBxMIZhAFGdRIj0H2ZSJJKlMLUiczIjSYsbTczNctNChI8oMp/9McDVhxUkos0+RWPlBLKqVKEw/rhZCMrVsU7DAkPyI4oJt1K9pnbiAe3aGWbydnESxQkyqE6iIMTU951jQZLl/H0OWC7Wy5civ6GrezPnyZ86GTKM+B3pe69WwrwYCACH5BAkGAGAALAAAAAAoACgAhjSClJzG1NTm7Gy2xKTm9Ozy9GSitLzW3NT2/MTq9ITO3Jza7HyqtFSSpNzy9IS6zGyqvMz+/Oz6/Lze7OT29Lzu/KzO1LTm9EyarITK3Pz6/ESKnOTq7GSmtLTe7JTCzMzi5FyarKTGzNzq7Kzq/NT+/Mzm7JTi9OTu9IzCzGyyxPT6/MTi5OT+/Mzu9DyClNTq7Hy2xKTq/GyerLza3JTW5Jzi9ISyvIy6xOT6/LTO1FSarMzq7JzK1HS6zKTm/Oz2/Nz6/IzO5KTe7HyuvNzy/HSuvOz+/Lzi7OT2/MTy/KzS3LTq/Pz+/EyOnGymtLTi7FyetKTG1Nz+/OTy9HSyxPT+/MTi7Mzy/DyGnNTq9GyirLza5Iy+zFSerMzq9P///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAf+gGCCg4SEVECFiYqLjIM4Ro2RklYmTYIHG5aSm4lUO1qCEgACnKWEKVWaIQGmkk1FmkBRHoIfBq2RSSoTmksdEmAgWcC4jDwDHpYrED1NKxssxYxNXyq0YCxeVE1bXdKETUmaYDwqUGBNMQ9gUjvj0kkKC0Ca1ckoGCMCLyjfgxJDFEBZIcheEy0rVjjR4W/QqxpCElji4YOgoCc3GoJzoaAGrBXjdDixiMtKBQRWCFmBksFFIQ4ARkizouTHCRlKglhRlpKQhgYi/DWxgoCJTRJYeha6sUWjoCYSsDDJoejACw1OJRV4AaJYiQhgw4Z9R2gGQ1xTvqqN8HUK2axVipq8hYuuyZG0R+g6PNLia4QpR+YK9Tulxc6ngqU1MTxOLl+lep9aaREYXWR0kxnXTVxMbgvNm/UuroyYs+J3ck07TX25EOvW4FTDnk27tu3buBcFAgA7"/></div>');
            ntb.fadeIn("fast", function () {
                $.ajax({
                    url: 'Ajax/GetBulletin/' + uuid,
                    type: 'get',
                    dataType: 'json',
                    success: function (result) {
                        if (result.flag === 'success') {
                            ntb.fadeOut("fast", function () {
                                var base = new Base64();
                                ntb.html("<div class='page-header'><h1>" + result.data.title +
                                    "</h1></div><div>" + base.decode(result.data.cont) + "</div>");
                                ntb.fadeIn("fast");
                            });
                        }
                    }
                });
            });
        });
    }
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

loadScript("https://code.jquery.com/jquery-1.12.4.min.js", function () {
    loadScript("https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js", function () {
    });
    loadScript("https://cdn.bootcss.com/messenger/1.5.0/js/messenger.min.js", function () {
        loadCSS("https://cdn.bootcss.com/messenger/1.5.0/css/messenger.min.css", function () {
        });
        loadCSS("https://cdn.bootcss.com/messenger/1.5.0/css/messenger-theme-flat.min.css", function () {
        });
        loadScript("https://cdn.bootcss.com/messenger/1.5.0/js/messenger-theme-flat.min.js", function () {
            Messenger.options = {
                extraClasses: 'messenger-fixed messenger-on-bottom',
                theme: 'flat'
            }
        });
    });
    loadScript("https://cdn.bootcss.com/scrollup/2.4.1/jquery.scrollUp.min.js", function () {
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
    pageScript(window.location.pathname.split('/')[1].toLowerCase());
});

function Base64() {

    // private property  
    _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    // public method for encoding  
    this.encode = function (input) {
        var output = "";
        var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
        var i = 0;
        input = _utf8_encode(input);
        while (i < input.length) {
            chr1 = input.charCodeAt(i++);
            chr2 = input.charCodeAt(i++);
            chr3 = input.charCodeAt(i++);
            enc1 = chr1 >> 2;
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
            enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
            enc4 = chr3 & 63;
            if (isNaN(chr2)) {
                enc3 = enc4 = 64;
            } else if (isNaN(chr3)) {
                enc4 = 64;
            }
            output = output +
                _keyStr.charAt(enc1) + _keyStr.charAt(enc2) +
                _keyStr.charAt(enc3) + _keyStr.charAt(enc4);
        }
        return output;
    };

    // public method for decoding  
    this.decode = function (input) {
        var output = "";
        var chr1, chr2, chr3;
        var enc1, enc2, enc3, enc4;
        var i = 0;
        input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
        while (i < input.length) {
            enc1 = _keyStr.indexOf(input.charAt(i++));
            enc2 = _keyStr.indexOf(input.charAt(i++));
            enc3 = _keyStr.indexOf(input.charAt(i++));
            enc4 = _keyStr.indexOf(input.charAt(i++));
            chr1 = (enc1 << 2) | (enc2 >> 4);
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
            chr3 = ((enc3 & 3) << 6) | enc4;
            output = output + String.fromCharCode(chr1);
            if (enc3 != 64) {
                output = output + String.fromCharCode(chr2);
            }
            if (enc4 != 64) {
                output = output + String.fromCharCode(chr3);
            }
        }
        output = _utf8_decode(output);
        return output;
    };

    // private method for UTF-8 encoding  
    _utf8_encode = function (string) {
        string = string.replace(/\r\n/g, "\n");
        var utftext = "";
        for (var n = 0; n < string.length; n++) {
            var c = string.charCodeAt(n);
            if (c < 128) {
                utftext += String.fromCharCode(c);
            } else if ((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            } else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }

        }
        return utftext;
    };

    // private method for UTF-8 decoding  
    _utf8_decode = function (utftext) {
        var string = "";
        var i = 0;
        var c = c1 = c2 = 0;
        while (i < utftext.length) {
            c = utftext.charCodeAt(i);
            if (c < 128) {
                string += String.fromCharCode(c);
                i++;
            } else if ((c > 191) && (c < 224)) {
                c2 = utftext.charCodeAt(i + 1);
                string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                i += 2;
            } else {
                c2 = utftext.charCodeAt(i + 1);
                c3 = utftext.charCodeAt(i + 2);
                string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                i += 3;
            }
        }
        return string;
    }
}