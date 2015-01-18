<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" Title="十三班 - CAS"  CodeFile="Personal.aspx.cs" Inherits="Personal" %>
<asp:Content ID="script" ContentPlaceHolderID="script" Runat="Server" >
    <script>Script("personal");</script>
    <script src="js/jquery.Jcrop.min.js"></script>
	<link href="css/jquery.Jcrop.min.css" rel="stylesheet" />
</asp:content>

<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
    <div class="container fixedfirst">
        <div class="page-header">
            <h1>个人 <small>资料更改</small></h1>
        </div>
    </div>
    <%if (Session["username"] != null){ %>
    <div class="container" style="min-height: 450px;">
        <ul id="Tab" class="nav nav-tabs">
            <li class="active"><a href="#info" data-toggle="tab">资料</a></li>
            <li class=""><a href="#head" data-toggle="tab">头像</a></li>
            <li class=""><a href="#pwd" data-toggle="tab">密码</a></li>
            <li class=""><a href="Addressbook.aspx">通讯录</a></li>
        </ul>
        <form runat="server" id="TabContent" class="tab-content">
            <div class="tab-pane active" id="info">
                <script>$(function () { $("#main_QQ").val('<%=infoa[0]%>'); $("#main_birthday").val('<%=infoa[3]%>'); $("#main_phone").val('<%=infoa[2]%>'); $("#main_mail").val('<%=infoa[1]%>'); });</script>
                <div class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="birthday">生日</label>
                            <div class="col-sm-6">
                                <asp:TextBox ID="birthday" runat="server" TextMode="Date" MaxLength="50" CssClass="form-control"></asp:TextBox>
                                <p class="help-block">请按格式填写</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="QQ">QQ</label>
                            <div class="col-sm-6">
                                <asp:TextBox ID="QQ" runat="server" TextMode="Phone" placeholder="QQ" MaxLength="50" CssClass="form-control"></asp:TextBox>
                                <p class="help-block">阁下的QQ号码</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="phone">手机</label>
                            <div class="col-sm-6">
                                <asp:TextBox ID="phone" runat="server" TextMode="Phone" placeholder="手机" MaxLength="50" CssClass="form-control"></asp:TextBox>
                                <p class="help-block">阁下的手机</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="mail">邮箱</label>
                            <div class="col-sm-6">
                                <asp:TextBox ID="mail" runat="server" placeholder="邮箱" TextMode="Email" MaxLength="50" CssClass="form-control"></asp:TextBox>
                                <p class="help-block">阁下的邮箱</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-6">
                                <asp:Button ID="Updateinfo" runat="server" Text="提交" OnClick="Updateinfo_Click" CssClass="btn btn-primary"/>
                            </div>
                        </div>
                </div>
            </div>
            <div class="tab-pane" id="head" style="overflow:hidden">
                <div class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="FileHead">待裁切照片</label>
                            <div class="col-sm-6">
                                <asp:FileUpload ID="FileHead" runat="server"/>
                                <p class="help-block">仅支持jpg格式图像</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-6">
                                <asp:Button ID="UploadHead" runat="server" Text="上传" CssClass="btn btn-primary" OnClick="UploadHead_Click" />
                            </div>
                        </div>
                </div>
                <hr>
                <%if (Session["tempimg"]!=null && System.IO.File.Exists(Server.MapPath("Photo") + "\\" + Session["tempimg"].ToString()))
                  { %>

                <div style="display:none">
                    <label>X1<input type="text" size="4" id="x" name="x" /></label>
                    <label>Y1<input type="text" size="4" id="y" name="y" /></label>
                    <label>X2<input type="text" size="4" id="x2" name="x2" /></label>
                    <label>Y2<input type="text" size="4" id="y2" name="y2" /></label>
                    <label>W<input type="text" size="4" id="w" name="w" /></label>
                    <label>H<input type="text" size="4" id="h" name="h" /></label>
                </div>
                <div>
                    <img src="Photo/<%=Session["tempimg"].ToString() %>" id="target" />
                    <div id="preview-pane" style="display: none">
                        <div class="preview-container">
                            <img src="Photo/<%=Session["tempimg"].ToString() %>" class="jcrop-preview"/>
                        </div>
                        <p id="headok" style="text-align: center; margin-top: 5px;">
                            <asp:Button ID="Button1" runat="server" Text="保存" CssClass="btn btn-primary" OnClick="Savehead_Click" /></p>
                    </div>
                </div>
                <%} %>
            </div>
            <div class="tab-pane" id="pwd">

                <div class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="opwd">原密码</label>
                            <div class="col-sm-6">
                                <asp:TextBox ID="opwd" runat="server" MaxLength="20" TextMode="Password" placeholder="原密码" CssClass="form-control"></asp:TextBox>
                                <p class="help-block">键入当前的密码</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="newpwd">新密码</label>
                            <div class="col-sm-6">
                                <asp:TextBox ID="newpwd" runat="server" MaxLength="20" TextMode="Password" placeholder="新密码" CssClass="form-control"></asp:TextBox>
                                <p class="help-block">6-20位的新密码。</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="rnpwd">确认密码</label>
                            <div class="col-sm-6">
                                <asp:TextBox ID="rnpwd" runat="server" MaxLength="20" TextMode="Password" placeholder="重复确认" CssClass="form-control"></asp:TextBox>
                                <p class="help-block">再次键入防止错误。</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-6">
                                <asp:Button ID="changepwd" runat="server" Text="提交"  CssClass="btn btn-primary"/>
                            </div>
                        </div>
                </div>

            </div>
        </form>
    </div>
    <%}
      else { Response.Write("<div class='container'><div class='alert alert-warning'>请登录查看该页面</div></div>"); } %>
    <script>$(function () { <%=page_script%> });</script>
</asp:Content>