<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" CodeFile="Gallery.aspx.cs" Inherits="Gallery" %>
<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
    <div class="container">
        <div class="page-header">
            <h1>图库 <small>班级相册</small></h1>
            <%if (CAS.User.Current.Permission(CAS.User.PermissionType.PHOTOSUB) != 0) {%>
            <button data-toggle="modal" data-target="#submit" class="pull-right btn btn-primary">上传照片</button>
            <%} %>
        </div>
    </div>
    <div class="container" id="gallery">
        <div class="btn-group pull-left" style="margin-top: -69px;margin-left: 190px;">
            <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                集 <span class="caret"></span>
            </button>
            <ul class="dropdown-menu" role="menu">
                <li class="filter" data-filter="all"><a>全部</a></li>
                <%=OnPage[1]%>
            </ul>
        </div>
		<ul class="just row">
			<%=OnPage[0]%>
		</ul>
    </div>
    
    <div class="modal fade" id="submit" tabindex="-1" role="dialog">
        <form>
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4>上传照片</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label class="col-sm-2 control-label" for="title">标题</label>
                                <div class="col-sm-10">
                                    <input class="form-control" type="text" id="title" maxlength="50">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label" for="file">文件</label>
                                <div class="col-sm-10">
                                    <input class="file" id="file" type="file" data-allowed-file-extensions='["jpg", "jpeg"]'>
                                </div>
                            </div>
                            <p>仅接受jpg格式文件。</p>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-primary" type="button" onclick="$('#file').fileinput('upload');">提交</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <script src="//cdn.bootcss.com/bootstrap-fileinput/4.2.7/js/fileinput.min.js"></script>
    <script src="//cdn.bootcss.com/bootstrap-fileinput/4.2.7/js/fileinput_locale_zh.min.js"></script>
    <link rel="stylesheet" href="//cdn.bootcss.com/bootstrap-fileinput/4.2.7/css/fileinput.min.css">

</asp:Content>
<asp:Content ID="script" ContentPlaceHolderID="script" Runat="Server">
    <script src="//cdn.bootcss.com/jquery.swipebox/1.4.1/js/jquery.swipebox.min.js"></script>
    <link href="//cdn.bootcss.com/jquery.swipebox/1.4.1/css/swipebox.min.css" rel="stylesheet" />
    <script src="//cdn.bootcss.com/mixitup/2.1.11/jquery.mixitup.min.js"></script>
    <script src="//cdn.bootcss.com/bootstrap-fileinput/4.2.7/js/fileinput.min.js"></script>
    <script src="//cdn.bootcss.com/bootstrap-fileinput/4.2.7/js/fileinput_locale_zh.min.js"></script>
    <link rel="stylesheet" href="//cdn.bootcss.com/bootstrap-fileinput/4.2.7/css/fileinput.min.css">

    <script src="js/gallery.js"></script>
</asp:Content>