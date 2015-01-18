<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" Title="十三班 - CAS" CodeFile="Gallery.aspx.cs" Inherits="Gallery" %>
<asp:Content ID="script" ContentPlaceHolderID="script" Runat="Server" >
    <script src="js/jquery.mixitup.min.js"></script>
    <script src="js/jquery.swipebox.min.js"></script>
    <script src="js/ajaxfileupload.js"></script>
	<link rel="stylesheet" type="text/css" href="css/swipebox.css">
    <script>Script("gallery");</script>
</asp:content>

<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
    <div class="container">
        <div class="page-header">
            <h1>图库 <small>班级相册</small></h1>
            <button id="iomodalbt" data-toggle="modal" data-target="#iomodal" class="pull-right btn-primary btn" style="display:none">上传照片</button>
        </div>
    </div>
    <div class="container">
        <div class="btn-group pull-right" style="margin-top: -69px;margin-right: 100px;">
            <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                集 <span class="caret"></span>
            </button>
            <ul class="dropdown-menu" role="menu">
                <li class="filter" data-filter="all"><a>全部</a></li>
                <li class="filter" data-filter=".长沙"><a>长沙行</a></li>
                <li class="filter" data-filter=".体育节"><a>体育节</a></li>
            </ul>
        </div>
    </div>
    <div class="container">
		<ul id="galleryul" class="just row">
			<%=back%>
		</ul>
    </div>
    
    <div class="modal fade" id="iomodal" tabindex="-1" role="dialog" aria-labelledby="iomodallabel" aria-hidden="true">
        <form id="ioformsub" role="form">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4>上传照片</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label class="col-sm-2 control-label" for="title">标题</label>
                                <div class="col-sm-10">
                                    <input class="form-control" type="text" id="title">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label" for="iofile">文件</label>
                                <div class="col-sm-10">
                                    <input id="iofile" class="form-control" name="iofile" type="file">
                                </div>
                            </div>
                            <p>仅接受jpg格式文件。</p>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-primary" type="submit" id="iosub">提交</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</asp:Content>