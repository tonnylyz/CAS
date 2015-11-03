<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="CAS.Login" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CAS - Login</title>
    <link href="//cdn.bootcss.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet">
    <script src="//cdn.bootcss.com/jquery/2.1.4/jquery.min.js"></script>
    <script src="//cdn.bootcss.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
    <link href="css/login.css" rel="stylesheet">
    <script src="js/login.js"></script>
    <link href="//cdn.bootcss.com/messenger/1.4.2/css/messenger.min.css" rel="stylesheet" />
    <link href="//cdn.bootcss.com/messenger/1.4.2/css/messenger-theme-flat.min.css" rel="stylesheet" />
    <script src="//cdn.bootcss.com/messenger/1.4.2/js/messenger.min.js"></script>
    <script src="//cdn.bootcss.com/messenger/1.4.2/css/messenger-theme-flat.min.css"></script>
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
                                <li><a href="Default.aspx">主页</a></li>
                                <li class="active"><a href="#">登录</a></li>
                                <li><a href="About.aspx">关于</a></li>
                            </ul>
                        </nav>
                    </div>
                </div>
                <div class="inner cover">
                    <h1 class="cover-heading">登录</h1>
                    <form id="login-form">
                        <input type="text" id="username" class="form-control" placeholder="用户名">
                        <br>
                        <input type="password" id="password" class="form-control" placeholder="密码">
                        <br>
                        <p class="lead">
                            <button class="btn btn-default" id="loginsub" type="submit">登录</button>
                        </p>
                    </form>
                </div>
                <div class="mastfoot">
                    <div class="inner">
                        <p>&copy; 2015 深圳中学 十三班 &middot; <a href="About.aspx">关于</a> &middot; 纪念版</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

