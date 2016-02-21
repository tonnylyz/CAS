<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" CodeFile="Addressbook.aspx.cs" Inherits="Addressbook" %>
<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
    <div class="container">
        <div class="page-header">
            <h1>班级 <small>通讯录</small></h1>
        </div>
    </div>
    <div class="container" id="addressbook">
        <div class="row"></div>
    </div>
    <div id="info" class="modal fade" tabindex="-1" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="phone">手机</label>
                            <div class="col-sm-6">
                                <input class="form-control" type="text" id="phone">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="mail">邮箱</label>
                            <div class="col-sm-6">
                                <input class="form-control" type="text" id="mail">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="qq">QQ</label>
                            <div class="col-sm-6">
                                <input class="form-control" type="text" id="qq">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="username">用户名</label>
                            <div class="col-sm-6">
                                <input class="form-control" type="text" id="username">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="cbirth">生日</label>
                            <div class="col-sm-6">
                                <input class="form-control" type="text" id="birth">
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-default" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
<asp:Content ID="script" ContentPlaceHolderID="script" Runat="Server">
    <script src="js/addressbook.js"></script>
</asp:Content>