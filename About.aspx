<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" Title="十三班 - CAS" CodeFile="About.aspx.cs" Inherits="About" %>
<asp:Content ID="script" ContentPlaceHolderID="script" Runat="Server" >
	<script>Script("about");</script>
</asp:content>

<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
    <div class="container">
        <div class="page-header">
            <h1>关于 <small>CAS</small></h1>
        </div>
    </div>
    <div class="container">
        <p>CAS now is a project of <a href="http://lab.xuehuo.org">CUBES Lab</a>.</p>
        <p>Original author: <a href="http://www.lyzde.com">Tonny Leung</a>.</p>
        <p>CAS Version: 7.0.3.0 (Alpha) EXT14 Build 20150118<br />This software is released under the <a href="http://www.gnu.org/licenses/lgpl.html">LGPL</a>.</p>
    </div>
</asp:Content>