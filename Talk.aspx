<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" CodeFile="Talk.aspx.cs" Inherits="Talk" %>
<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
    <div class="container">
        <div class="page-header">
            <h1>说说 <small>历史记录</small></h1>
        </div>
    </div>
    <div class="container" id="talk">
        <div></div>
    </div>
</asp:Content>
<asp:Content ID="script" ContentPlaceHolderID="script" Runat="Server">
    <script src="js/talk.js"></script>
</asp:Content>