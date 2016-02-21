<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" CodeFile="Personal.aspx.cs" Inherits="Personal" %>
<asp:Content ID="main" ContentPlaceHolderID="main" runat="Server">
    <div class="container">
        <div class="page-header">
            <h1>个人 <small>资料更改</small></h1>
        </div>
    </div>
    <div class="container" id="personal">
        <ul class="nav nav-tabs">
            <li class="active"><a href="#info" data-toggle="tab">资料</a></li>
            <li class=""><a href="#avatar" data-toggle="tab">头像</a></li>
            <li class=""><a href="#pwd" data-toggle="tab">密码</a></li>
            <li class=""><a href="Addressbook.aspx">通讯录</a></li>
        </ul>
        <div class="tab-content">
            <div class="tab-pane active" id="info">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="birthday">生日</label>
                        <div class="col-sm-6">
                            <input type="text" id="birthday" class="form-control" data-date-format="YYYY-MM-DD" placeholder="生日" maxlength="10">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="qq">QQ</label>
                        <div class="col-sm-6">
                            <input type="text" id="qq" class="form-control" placeholder="QQ" maxlength="12">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="phone">手机</label>
                        <div class="col-sm-6">
                            <input type="text" id="phone" class="form-control" placeholder="手机" maxlength="11">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="mail">邮箱</label>
                        <div class="col-sm-6">
                            <input type="text" id="mail" class="form-control" placeholder="邮箱" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="intro">自我介绍</label>
                        <div class="col-sm-6">
                            <input type="text" id="intro" class="form-control" placeholder="自我介绍" maxlength="255">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-6">
                            <button type="submit" class="btn btn-primary">提交</button>
                        </div>
                    </div>
                </form>
            </div>
            <div class="tab-pane" id="avatar" style="overflow: hidden">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="file">待裁切照片</label>
                        <div class="col-sm-6">
                            <input id="file" class="file" type="file">
                            <p class="help-block">仅支持jpg格式图像，请不要在移动设备完成这项操作。</p>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-6">
                            <button type="button" onclick="$('#file').fileinput('upload');" class="btn btn-primary">提交</button>
                        </div>
                    </div>
                </form>
                <div class="row" style="display: none;">
                    <div class="col-md-8">
                        <img src="#"/></div>
                    <div class="col-md-4" style="display:none">
                        <div class="preview-container">
                            <img src="#" class="jcrop-preview" />
                        </div>
                        <div style="text-align: center; margin-top: 5px;">
                            <form>
                                <button type="submit" class="btn btn-primary">提交</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="tab-pane" id="pwd">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="password">原密码</label>
                        <div class="col-sm-6">
                            <input type="password" id="password" class="form-control" placeholder="原密码" maxlength="20">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="passwordn">新密码</label>
                        <div class="col-sm-6">
                            <input type="password" id="passwordn" class="form-control" placeholder="新密码" maxlength="20">
                            <p class="help-block">请不要使用弱密码，最大长度20个字符。</p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="passwordr">确认密码</label>
                        <div class="col-sm-6">
                            <input type="password" id="passwordr" class="form-control" placeholder="确认" maxlength="20">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-6">
                            <button type="submit" class="btn btn-primary">提交</button>
                        </div>
                    </div>
                </form>

            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="script" ContentPlaceHolderID="script" Runat="Server">
    <script src="//cdn.bootcss.com/moment.js/2.10.6/moment.min.js"></script>
    <script src="//cdn.bootcss.com/bootstrap-datetimepicker/4.17.37/js/bootstrap-datetimepicker.min.js"></script>
    <link href="//cdn.bootcss.com/bootstrap-datetimepicker/4.17.37/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />
    <script src="//cdn.bootcss.com/bootstrap-fileinput/4.2.7/js/fileinput.min.js"></script>
    <script src="//cdn.bootcss.com/bootstrap-fileinput/4.2.7/js/fileinput_locale_zh.min.js"></script>
    <link rel="stylesheet" href="//cdn.bootcss.com/bootstrap-fileinput/4.2.7/css/fileinput.min.css">
    <script src="//cdn.bootcss.com/jquery-jcrop/0.9.12/js/jquery.Jcrop.min.js"></script>
    <link rel="stylesheet" href="//cdn.bootcss.com/jquery-jcrop/0.9.12/css/jquery.Jcrop.min.css">
    <script src="js/personal.js"></script>
</asp:Content>