<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" Title="十三班 - CAS"  CodeFile="Talk.aspx.cs" Inherits="Talk" %>
<asp:Content ID="script" ContentPlaceHolderID="script" Runat="Server" >
    <script>
        global_script("talk");
        function global_onlogout() {
            $('.alert').slideDown();
            $("#histalkct").slideUp();
            $("#histalkct").html("");
        }
        function global_onlogin() {
            talk_load();
        }
    </script>
</asp:content>

<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
    <div class="container">
        <div class="page-header">
            <h1>说说 <small>历史上的说说</small></h1>
        </div>
    </div>
    <div class="container">
        <div class="alert alert-warning alert-dismissable" style="display: <%if (Session["username"] != null) { Response.Write("none"); } else { Response.Write("block"); } %>">
            <strong>注意!</strong> 系统需要登陆才可查看该页面。请在右上角或折叠的菜单中点击“登陆”登陆。
        </div>
        <div id="histalkct">
        </div>
    </div>
</asp:Content>