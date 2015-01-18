<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" Title="十三班 - CAS"  CodeFile="Talk.aspx.cs" Inherits="Talk" %>
<asp:Content ID="script" ContentPlaceHolderID="script" Runat="Server" >
    <script>Script("talk");</script>
</asp:content>

<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
    <div class="container">
        <div class="page-header">
            <h1>说说 <small>历史上的说说</small></h1>
        </div>
    </div>
    <div class="container">
        <div id="histalkct"></div>
    </div>
</asp:Content>