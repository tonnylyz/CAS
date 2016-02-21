<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" CodeFile="Default.aspx.cs" Inherits="_Default" %>
<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
    <div class="container" id="default">
        <div class="jumbotron text-center">
        <%if (Session["firsttime"] != null){ %>
            <h1>Hello, world!</h1>
            <p>你已经完成了CAS的注册，到个人设定为自己添加头像吧！</p>
            <p><a class="btn btn-primary btn-lg" href="Personal.aspx" role="button">个人资料设定</a></p>
        <%} else {%>
            <h1>Welcome!</h1>
            <p>欢迎来到CAS，许多的功能正等着你去探索。</p>

        <%} %>
        </div>
        <div class="row">
            <div class="col-sm-4">
                <h2>公告 <small><a href="Bulletin.aspx">更多</a></small></h2>
                <div class="bs-sidebar">
                	<%=onPage[0]%>
                </div>
            </div>
            <div class="col-sm-4">
                <h2>图库 <small><a href="Gallery.aspx">更多</a></small></h2>
                <div class="bs-sidebar">
                    <img class="img-responsive img-thumbnail" src="Photo/<%=onPage[1] %>_thumb.jpg">
                </div>
            </div>
            <div class="col-sm-4">
                <h2>生日 <small><a href="Calendar.aspx">更多</a></small></h2>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>姓名</th>
                            <th>生日</th>
                        </tr>
                    </thead>
                    <tbody id="birthday">
                        <%=onPage[2] %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>