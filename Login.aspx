<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CAS - Login</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/login.css" rel="stylesheet">
</head>
<body>
    <div class="site-wrapper">
        <div class="site-wrapper-inner">
            <div class="cover-container">
                <div class="masthead clearfix">
                    <div class="inner">
                        <h3 class="masthead-brand">CAS</h3>
                        <nav>
                            <ul class="nav masthead-nav">
                                <li class="active"><a href="#">主页</a></li>
                                <li><a href="#">管理</a></li>
                                <li><a href="About.aspx">关于</a></li>
                            </ul>
                        </nav>
                    </div>
                </div>
                <div class="inner cover">
                    <h1 class="cover-heading">登录</h1>
                    <form id="login-form">
                        <div class="input-group">
                            <input type="text" id="username" class="form-control" placeholder="用户名">
                            <span class="input-group-addon">@</span>
                            <input type="text" id="classnum" class="form-control" placeholder="班级"data-toggle="tooltip" data-placement="top" title="请按照格式213来填写班级高二(13)班">
                        </div>
                        <br>
                        <input type="password" id="password" class="form-control" placeholder="密码">
                        <br>
                        <p class="lead">
                            <button class="btn btn-default" id="loginsub" type="submit">登录</button>
                        </p>
                        <p class="text-muted"><a href="#">忘记密码</a> | <a href="#">注册</a></p>
                    </form>
                </div>
                <div class="mastfoot">
                    <div class="inner">
                        <p>Copyright &copy; 2015 CUBES Lab. CAS is licensed under <a href="http://www.gnu.org/licenses/lgpl.html">LGPL</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <link href="css/messenger.css" rel="stylesheet" />
    <link href="css/messenger-theme-flat.css" rel="stylesheet" />
    <script src="js/messenger.min.js"></script>
    <script src="js/messenger-theme-flat.js"></script>
    <script src="js/login.js"></script>
</body>
</html>

