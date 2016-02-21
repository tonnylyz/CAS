<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" CodeFile="Calendar.aspx.cs" Inherits="Calendar" %>
<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
	<div class="container">
        <div class="page-header">
            <h1>日历 <small>事项/生日</small></h1>
            <%if (CAS.User.Current.Permission(CAS.User.PermissionType.CALENDAR) != 0) {%>
            <button data-toggle="modal" data-target="#submit" class="pull-right btn btn-primary">添加事项</button>
            <%} %>
        </div>
    </div>
    <div class="container" id="calendar">
        <div></div>
    </div>
    <div class="modal fade" id="submit" tabindex="-1" role="dialog">
        <form role="form">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4>添加事项</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label class="control-label col-sm-2 label-toggle-switch" for="last">持续</label>
                                <div class="col-sm-10">
                                    <div class="bootstrap-switch bootstrap-switch-on bootstrap-switch-animate">
                                        <div class="bootstrap-switch-container">
                                            <input type="checkbox" id="last" checked data-on-text="多日" data-off-text="单日">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label" for="start">起始日期</label>
                                <div class="col-sm-10">
                                    <input class="form-control" type="text" id="start" data-date-format="YYYY-MM-DD" placeholder="点击选择日期">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-2" for="end">结束日期</label>
                                <div class="col-sm-10">
                                    <input class="form-control" type="text" id="end" data-date-format="YYYY-MM-DD" placeholder="点击选择日期">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-2" for="info">描述</label>
                                <div class="col-sm-10">
                                    <input class="form-control" type="text" id="info" maxlength="50">
                                </div>
                            </div>
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
    <script src="//cdn.bootcss.com/moment.js/2.10.6/moment.min.js"></script>
    <script src="//cdn.bootcss.com/fullcalendar/2.4.0/fullcalendar.min.js"></script>
    <script src="//cdn.bootcss.com/fullcalendar/2.4.0/lang/zh-cn.js"></script>
    <link href="//cdn.bootcss.com/fullcalendar/2.4.0/fullcalendar.min.css" rel="stylesheet" />
    
    <script src="//cdn.bootcss.com/bootstrap-datetimepicker/4.17.37/js/bootstrap-datetimepicker.min.js"></script>
    <link href="//cdn.bootcss.com/bootstrap-datetimepicker/4.17.37/css/bootstrap-datetimepicker.min.css" rel="stylesheet" />
    <script src="//cdn.bootcss.com/bootstrap-switch/3.3.2/js/bootstrap-switch.min.js"></script>
    <link href="//cdn.bootcss.com/bootstrap-switch/3.3.2/css/bootstrap3/bootstrap-switch.min.css" rel="stylesheet" />

    <script src="js/calendar.js"></script>
</asp:Content>