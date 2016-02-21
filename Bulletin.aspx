<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" CodeFile="Bulletin.aspx.cs" Inherits="Bulletin" %>
<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
	<div class="container">
        <div class="page-header">
            <h1>班级 <small>通知公告</small></h1>
            <%if (CAS.User.Current.Permission(CAS.User.PermissionType.BULLETIN) != 0) {%>
            <button data-toggle="modal" data-target="#submit" class="pull-right btn btn-primary">发布公告</button>
            <%} %>
        </div>
    </div>
    <div class="container" id="bulletin">
        <div class="row">
            <div class="col-sm-3">
				<div class="bs-sidebar">
                    <ul class="nav bs-sidenav" id="list">
					    <%=onPage[0]%>
                    </ul>
				</div>
            </div>
            <div class="col-sm-9">
                <div id="notice">
                    <%if (onPage[1] != null)
                            Response.Write("<div class=\"page-header\"><h1>" + onPage[1] + " <small>" + onPage[3] + "</small></h1></div><div>" + onPage[2] + "</div>");
                    %>
                </div>
                <div class="well<%if (Request["ID"] != null){ %> hidden<%}%>" id="default" >
                    <h2>通知公告</h2>
                    <p>欲知班级大事事宜，且看公告一览无余。</p>
                    <p>在右侧目录搜寻或在下方检索。</p>
                    <form class="form-horizontal">
                        <fieldset>
                            <div id="legend">
                                <h4>全文检索</h4>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">关键字</label>
                                <div class="col-sm-10">
                                    <input placeholder="关键字" class="form-control" id="key" type="text" maxlength="255">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">检索</label>
                                <div class="col-sm-10">
                                    <button class="btn btn-success disabled" type="submit">全文检索</button>
                                </div>
                            </div>
                        </fieldset>
                    </form>
                </div>
            </div>
        </div>
        <div class="clearfix"></div>
    </div>
    <div class="modal fade" id="submit" tabindex="-1" role="dialog">
        <form role="form">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4>公告发布</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label class="control-label" for="title">标题</label>
                            <input class="form-control" type="text" id="title" placeholder="标题" maxlength="50">
                        </div>
                        <div class="form-group">
                            <label class="control-label" for="content">内容</label>
                            <textarea id="content"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                        <button class="btn btn-primary" type="submit">提交</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</asp:Content>
<asp:Content ID="script" ContentPlaceHolderID="script" Runat="Server">
    <script src="//cdn.bootcss.com/tinymce/4.2.7/tinymce.min.js"></script>
    <script src="js/bulletin.js"></script>
</asp:Content>