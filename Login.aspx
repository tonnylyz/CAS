<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>
<!DOCTYPE html>
<html>
<head id="head">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CAS - Login</title>
    <link href="css/login.css" rel="stylesheet">
</head>
<body>
    <div class="site-wrapper">
        <div class="site-wrapper-inner">
            <div class="cover-container">
                <div class="masthead clearfix">
                    <div class="inner">
                        <h3 class="masthead-brand">CAS <small>Class Associative System</small></h3>
                    </div>
                </div>
                <div class="inner cover">
                    <h1 class="cover-heading">登录</h1>
                    <form>
                        <input type="text" id="username" class="form-control" placeholder="用户名（或学号）">
                        <br>
                        <input type="password" id="password" class="form-control" placeholder="密码">
                        <br>
                        <p class="lead">
                            <button class="btn btn-default" type="submit">登录</button> <a class="btn" href="#" data-toggle="modal" data-target="#submit">注册</a>
                        </p>
                        <p class="text-muted fade">
                            若忘记密码，请发送邮件至 <a href="mailto:webmaster@domain">webmaster@domain</a></p>
                    </form>
                </div>
                <div class="mastfoot">
                    <div class="inner">
                        <p>Copyright &copy; 2016 CUBES Lab. CAS is licensed under <a href="http://www.gnu.org/licenses/lgpl.html">LGPL</a>.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="submit" tabindex="-1" role="dialog">
        <form>
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4>注册</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-horizontal">
                            <div class="well">
                                <p>本框内的填写项目将会被核对，错误的填写会使注册失败。</p>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="reg-realname">姓名</label>
                                    <div class="col-sm-10">
                                        <input class="form-control" type="text" id="reg-realname" placeholder="姓名" maxlength="10">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="reg-SN">学号</label>
                                    <div class="col-sm-10">
                                        <input class="form-control" type="text" id="reg-SN" placeholder="学号" maxlength="8">
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label" for="reg-username">用户名</label>
                                <div class="col-sm-10">
                                    <input class="form-control" type="text" id="reg-username" placeholder="用户名" maxlength="10">
                                    <p class="help-block">建议不要使用中文，英文区分大小写，最大长度10个字符。</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label" for="reg-pwd">密码</label>
                                <div class="col-sm-10">
                                    <input class="form-control" type="text" id="reg-pwd" placeholder="密码" maxlength="20">
                                    <p class="help-block">请不要使用弱密码，最大长度20个字符。</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label" for="reg-birthday">生日</label>
                                <div class="col-sm-10">
                                    <input type="text" id="reg-birthday" class="form-control" placeholder="生日" maxlength="10">
                                    <p class="help-block">请按格式填写，如1997-1-1。</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label" for="reg-qq">QQ</label>
                                <div class="col-sm-10">
                                    <input type="text" id="reg-qq" class="form-control" placeholder="QQ" maxlength="12">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label" for="reg-phone">手机</label>
                                <div class="col-sm-10">
                                    <input type="text" id="reg-phone" class="form-control" placeholder="手机" maxlength="11">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label" for="reg-mail">邮箱</label>
                                <div class="col-sm-10">
                                    <input type="text" id="reg-mail" class="form-control" placeholder="邮箱" maxlength="50">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label" for="reg-intro">自我介绍</label>
                                <div class="col-sm-10">
                                    <input type="text" id="reg-intro" class="form-control" placeholder="自我介绍" maxlength="255">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-primary btn-block" type="submit">提交</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <script src="//cdn.bootcss.com/jquery/2.1.4/jquery.min.js"></script>
    <script src="//cdn.bootcss.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
    <script src="//cdn.bootcss.com/messenger/1.4.2/js/messenger.min.js"></script>
    <script src="//cdn.bootcss.com/messenger/1.4.2/js/messenger-theme-flat.js"></script>
    <link href="//cdn.bootcss.com/messenger/1.4.2/css/messenger.min.css" rel="stylesheet" />
    <link href="//cdn.bootcss.com/messenger/1.4.2/css/messenger-theme-flat.min.css" rel="stylesheet" />
    <script src="js/login.js"></script>
</body>
</html>

