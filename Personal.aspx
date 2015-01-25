<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" CodeFile="Personal.aspx.cs" Inherits="Personal" %>

<asp:Content ID="main" ContentPlaceHolderID="main" runat="Server">
    <div class="container fixedfirst">
        <div class="page-header">
            <h1>个人 <small>资料更改</small></h1>
        </div>
    </div>
    <div class="container" style="min-height: 450px;">
        <ul id="Tab" class="nav nav-tabs">
            <li class="active"><a href="#info" data-toggle="tab">资料</a></li>
            <li class=""><a href="#avatar" data-toggle="tab">头像</a></li>
            <li class=""><a href="#pwd" data-toggle="tab">密码</a></li>
            <li class=""><a href="Addressbook.aspx">通讯录</a></li>
        </ul>
        <div id="TabContent" class="tab-content">
            <div class="tab-pane active" id="info">
                <form id="infoform" class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="birthday">生日</label>
                        <div class="col-sm-6">
                            <input type="text" id="birthday" class="form-control" placeholder="生日">
                            <p class="help-block">请按格式填写</p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="QQ">QQ</label>
                        <div class="col-sm-6">
                            <input type="text" id="QQ" class="form-control" placeholder="QQ">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="phone">手机</label>
                        <div class="col-sm-6">
                            <input type="text" id="phone" class="form-control" placeholder="手机">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="mail">邮箱</label>
                        <div class="col-sm-6">
                            <input type="text" id="mail" class="form-control" placeholder="邮箱">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-6">
                            <button type="submit" id="infosub" class="btn btn-primary">提交</button>
                        </div>
                    </div>
                </form>
            </div>
            <div class="tab-pane" id="avatar" style="overflow: hidden">
                <form id="avatarform" class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="FileHead">待裁切照片</label>
                        <div class="col-sm-6">
                            <input id="iofile" class="form-control" name="iofile" type="file">
                            <p class="help-block">仅支持jpg格式图像，请不要在移动设备完成这项操作。</p>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-6">
                            <button type="submit" id="avatarsub" class="btn btn-primary">提交</button>
                        </div>
                    </div>
                </form>
                <div id="avatarcrop" style="display: none;">
                    <img src="#" id="target" />
                    <div id="preview-pane" style="display: none;">
                        <div class="preview-container">
                            <img src="#" class="jcrop-preview" />
                        </div>
                        <div style="text-align: center; margin-top: 5px;">
                            <form id="cropform">
                                <div style="display: none">
                                    <input type="text" size="4" id="x" name="x" />
                                    <input type="text" size="4" id="y" name="y" />
                                    <input type="text" size="4" id="x2" name="x2" />
                                    <input type="text" size="4" id="y2" name="y2" />
                                    <input type="text" size="4" id="w" name="w" />
                                    <input type="text" size="4" id="h" name="h" />
                                </div>
                                <button type="submit" id="cropsub" class="btn btn-primary">提交</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="tab-pane" id="pwd">
                <form id="passwordform" class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="opwd">原密码</label>
                        <div class="col-sm-6">
                            <input type="text" id="password" class="form-control" placeholder="原密码">
                            <p class="help-block">键入当前的密码</p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="newpwd">新密码</label>
                        <div class="col-sm-6">
                            <input type="text" id="passwordn" class="form-control" placeholder="新密码">
                            <p class="help-block">[6,20]位的新密码。</p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="rnpwd">确认密码</label>
                        <div class="col-sm-6">
                            <input type="text" id="passwordr" class="form-control" placeholder="确认">
                            <p class="help-block">再次键入防止错误。</p>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-6">
                            <button type="submit" id="passwordsub" class="btn btn-primary">提交</button>
                        </div>
                    </div>
                </form>

            </div>
        </div>
    </div>
</asp:Content>
