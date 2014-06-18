<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" Title="十三班 - CAS" CodeFile="About.aspx.cs" Inherits="About" %>
<asp:Content ID="script" ContentPlaceHolderID="script" Runat="Server" >
	<script>
	    global_script("about");
	    function global_onlogout() {

	    }
	    function global_onlogin() {

	    }
	</script>
</asp:content>

<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
    <div class="container">
        <div class="page-header">
            <h1>关于 <small>十三班</small></h1>
        </div>
    </div>
    <div class="container">
        <p>CAS Version: 6.0.3.1 (Beta) EXT13 Build 20140426<br />This software is released under the <a href="http://www.gnu.org/licenses/lgpl.html">LGPL</a>.</p>
        <p>独立、自主、上进、卓越！</p>
    </div>
</asp:Content>