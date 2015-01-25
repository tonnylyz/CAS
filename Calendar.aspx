<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" CodeFile="Calendar.aspx.cs" Inherits="Calendar" %>
<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
	<div class="container">
        <div class="page-header">
            <h1>日历 <small>事项/生日</small></h1>
            <%if (Session["per"].ToString().Split(',')[3] != "0") {%>
            <button id="iomodalbt" data-toggle="modal" data-target="#iomodal" class="pull-right btn-primary btn">添加事项</button>
            <%} %>
        </div>
    </div>
    <div class="container">
        <div id='calendar'></div>
    </div>
    <div class="modal fade" id="iomodal" tabindex="-1" role="dialog" aria-labelledby="iomodallabel" aria-hidden="true">
        <form id="ioformsub" role="form">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                        <h4>添加事项</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label class="control-label col-sm-2 label-toggle-switch" for="iocheck">持续</label>
                                <div class="col-sm-10">
                                    <div class="bootstrap-switch bootstrap-switch-on bootstrap-switch-animate">
                                        <div class="bootstrap-switch-container">
                                            <input name="iocheck" checked id="iocheck" data-on-text="多日" data-off-text="单日" type="checkbox">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label" for="ioend">起始日期</label>
                                <div class="col-sm-10">
                                    <input class="form-control" type="text" id="iosta" data-date-format="yyyy-mm-dd" placeholder="点击选择日期">
                                </div>
                            </div>
                            <div class="form-group" id="sendb">
                                <label class="control-label col-sm-2" for="iocont">结束日期</label>
                                <div class="col-sm-10">
                                    <input class="form-control" type="text" id="ioend" data-date-format="yyyy-mm-dd" placeholder="点击选择日期">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-2" for="ioinfo">描述</label>
                                <div class="col-sm-10">
                                    <input class="form-control" type="text" id="ioinfo">
                                </div>
                            </div>
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