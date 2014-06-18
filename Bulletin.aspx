<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" Title="十三班 - CAS" CodeFile="Bulletin.aspx.cs" Inherits="Bulletin" %>
<asp:Content ID="script" ContentPlaceHolderID="script" Runat="Server" >
    <script src="js/tinymce/tinymce.min.js"></script>
    <script>
        global_script("bulletin");
        function global_onlogout() {
            $("#iomodalbt").fadeOut("fast");
        }
        function global_onlogin() {
            if (global_permission[4] == "1") {
                $("#iomodalbt").fadeIn("fast");
            }
        }
    </script>
</asp:content>

<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
	<div class="container">
        <div class="page-header">
            <h1>班级 <small>公告/通知</small></h1>
            <button id="iomodalbt" data-toggle="modal" data-target="#iomodal" class="pull-right btn-primary btn" style="display:none">发布公告</button>
        </div>
    </div>
    <div class="container" style="min-height: 450px;">
        <div class="row">
            <div class="col-md-3">
				<div class="bs-sidebar">
                    <ul class="nav bs-sidenav" id="bultlist">
					    <%=onpage[0]%>
                    </ul>
				</div>
            </div>
            <div class="col-md-9" id="bulletinboard">
                <div id="ntb">
                    <%if (onpage[1] != "null")
                          Response.Write("<div class='page-header'><h1>" + onpage[1] + "</h1></div><div>" + onpage[2] + "</div>");
                    %>
                </div>
                <div class="well" id="defaultb" <%if (Request["ID"] != null){ %>style="display:none"<%}%>>
                    <h2>公告</h2>
                    <p>欲知班级大事事宜，且看公告一览无余。</p>
                    <p>在右侧目录搜寻或在下方检索</p>
                    <form class="form-horizontal" id="searchformid">
                        <fieldset>
                            <div id="legend">
                                <legend class="">全文检索</legend>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">关键字</label>
                                <div class="col-sm-10">
                                    <input placeholder="关键字" class="form-control" type="text" id="searchkey">
                                    <p class="help-block">支持一个中文/英文关键字</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">检索</label>
                                <div class="col-sm-10">
                                    <button class="btn btn-success" id="searchsub" type="submit">全文检索</button>
                                </div>
                            </div>
                        </fieldset>
                    </form>
                </div>
            </div>
        </div>
        <div class="clearfix"></div>
    </div>
    <div class="modal fade" id="iomodal" tabindex="-1" role="dialog" aria-labelledby="iomodallabel" aria-hidden="true">
        <form id="ioformsub" role="form">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4>公告发布</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label class="control-label" for="iotitle">标题</label>
                            <input class="form-control" type="text" id="iotitle" placeholder="标题">
                        </div>
                        <div class="form-group">
                            <label class="control-label" for="iocontent">内容</label>
                            <textarea id="iocontent"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                        <button class="btn btn-primary" type="submit" id="iosub">提交</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</asp:Content>