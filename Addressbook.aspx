<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" Title="十三班 - CAS" CodeFile="Addressbook.aspx.cs" Inherits="Addressbook" %>
<asp:Content ID="script" ContentPlaceHolderID="script" Runat="Server" >
	<script>
	    global_script("addressbook");
	    function global_onlogout() {
	        $("#cardcont").html('');
	        $('.alert').fadeIn();
	    }
	    function global_onlogin() {
	        $('.alert').fadeOut();
	        addressbook_getinfo();
	    }
	</script>
</asp:content>

<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
    <div class="container">
        <div class="page-header">
            <h1>班级 <small>通讯录</small></h1>
        </div>
    </div>
    <div class="container">
        <div class="alert alert-warning" style="<%if (Session["username"] != null) { Response.Write("display:none"); }%>">
            您需要登录以查看这部分内容。请点击左上方或折叠菜单中登录按钮登录。
        </div>
        <div class="row" id="cardcont">
        </div>
    </div>

    <div id="cinfo" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="crealname"></h4>
                </div>
                <div class="modal-body">
        
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="cphone">手机</label>
                            <div class="col-sm-6">
                                <input class="form-control" type="text" id="cphone">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="cmail">邮箱</label>
                            <div class="col-sm-6">
                                <input class="form-control" type="text" id="cmail">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="cqq">QQ</label>
                            <div class="col-sm-6">
                                <input class="form-control" type="text" id="cqq">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="cusername">用户名</label>
                            <div class="col-sm-6">
                                <input class="form-control" type="text" id="cusername">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label" for="cbirth">生日</label>
                            <div class="col-sm-6">
                                <input class="form-control" type="text" id="cbirth">
                            </div>
                        </div>
                    </form>
        
                </div>
                <div class="modal-footer">
                    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">关闭</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>