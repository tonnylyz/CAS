<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" CodeFile="Homework.aspx.cs" Inherits="Homework" %>
<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
    <div class="container">
        <div class="page-header">
            <h1>资料库 <small>作业</small></h1>
            <%if (Session["per"].ToString().Split(',')[6] != "0") {%>
            <button id="iomodalbt" data-toggle="modal" data-target="#iomodal" class="pull-right btn-primary btn">作业登记</button>
            <%} %>
        </div>
    </div>
        <div class="container">
        <div class="row">
        	<div class="col-sm-4">
            	<h3>作业日期</h3>
                <div class="bs-sidebar">
                    <ul class="nav bs-sidenav" id="filedate">
                	    <%=back%>
                    </ul>
                </div>
            </div>
        	<div class="col-sm-8">
            	<h3>作业</h3>
                <div class="bs-sidebar">
                    <ul class="nav bs-sidenav" id="filelist">
                	    <li>请选择日期</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="iomodal" tabindex="-1" role="dialog" aria-labelledby="iomodallabel" aria-hidden="true">
        <form id="ioformsub" role="form">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4>作业登记</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label class="col-sm-2 control-label" for="iocont">作业</label>
                                <div class="col-sm-10">
                                    <textarea class="form-control" rows="8" id="iocont"></textarea>
                                </div>
                            </div>
                            <p>每一条作业占用一行，无需标号。</p>
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