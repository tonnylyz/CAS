<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" Title="十三班 - CAS" CodeFile="Filelib.aspx.cs" Inherits="Filelib" %>
<asp:Content ID="script" ContentPlaceHolderID="script" Runat="Server" >
    <script>
        global_script("filelib");
        function global_onlogin() {

        }
        function global_onlogout() {

        }
    </script>
</asp:content>

<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
    <div class="container fixedfirst">
        <div class="page-header">
            <h1>资料库 <small>课件</small></h1>
        </div>
    </div>
    <div class="container">
        <div class="row">
        	<div class="col-md-4">
            	<h3>文档日期</h3>
                <div class="bs-sidebar">
                    <ul class="nav bs-sidenav" id="datelist">
                	    <%=back%>
                    </ul>
                </div>
            </div>
        	<div class="col-md-4">
            	<h3>文档</h3>
                <div class="bs-sidebar">
                    <ul id="filelist" class="nav bs-sidenav">
                	    <li>请选择日期</li>
                    </ul>
                </div>
            </div>
        	<div class="col-md-4" id="infospan" style="display:none">
            	<h3>文档信息</h3>
                <h4 id="filename"></h4>
               	<div class="btn-group">
                    <a id="fileurl2" class="btn btn-info">下载</a>
                    <button type="button" onclick="filelib_thumbfile()" class="btn btn-default">预览</button>
                </div>
            </div>
        </div>
    </div>
    <div id="filethumbm" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="ftModalLabel" aria-hidden="true">
        <div class="modal-dialog" id="filethumb">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 id="filethumbname"></h4>
                </div>
                <div class="modal-body">
                    <iframe frameborder="0" src="" id="fileframe" width="100%" height="400px"></iframe>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">关闭</button>
                    <a href="#" id="fileurl" class="btn btn-primary">下载</a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>