<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" Title="十三班 - CAS" CodeFile="Default.aspx.cs" Inherits="_Default" %>
<asp:Content ID="script" ContentPlaceHolderID="script" Runat="Server" >
    <script>
        global_script("default");
        function global_onlogout() {

        }
        function global_onlogin() {

        }
    </script>
</asp:content>

<asp:Content ID="main" ContentPlaceHolderID="main" Runat="Server">
    <div class="container">
        <div id="Carousel" class="carousel slide" data-ride="carousel">
            <ol class="carousel-indicators">
                <li data-target="#Carousel" data-slide-to="0" class="active"></li>
                <li data-target="#Carousel" data-slide-to="1"></li>
                <li data-target="#Carousel" data-slide-to="2"></li>
            </ol>
            <div class="carousel-inner">
                <div class="item active">
                    <img src="img/slide1.jpg">
                    <div class="carousel-caption">
                        <h1>CAS 6.3</h1>
                        <p>全新版本的CAS将颠覆你对高中班级网站的想象！</p>
                    </div>
                </div>
                <div class="item">
                    <img src="img/slide2.jpg">
                    <div class="carousel-caption">
                        <h1>响应设计</h1>
                        <p>全新设计优化对平板、手机的支持。</p>
                    </div>
                </div>
                <div class="item">
                    <img src="img/slide3.jpg">
                    <div class="carousel-caption">
                        <h1>班级网站</h1>
                        <p>这里的一切都是为班级设计的。为我们的每一个同学。</p>
                    </div>
                </div>
            </div>
            <a class="left carousel-control" href="#Carousel" data-slide="prev">
                <span class="glyphicon glyphicon-chevron-left"></span>
            </a>
            <a class="right carousel-control" href="#Carousel" data-slide="next">
                <span class="glyphicon glyphicon-chevron-right"></span>
            </a>        
		</div>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-md-4">
                <h2>公告 <small><a href="Bulletin.aspx">更多</a></small></h2>
                <div id="noticespan" class="bs-sidebar">
                	<%=onpage[0]%>
                </div>
            </div>
            <div class="col-md-4">
                <h2>作业 <small id="homeworkdate"><%=onpage[3]%></small></h2>
                <div id="homeworkspan" class="bs-sidebar">
                	<%=onpage[1]%>
                </div>
            </div>
            <div class="col-md-4">
                <h2>课件 <small id="filedate"><%=onpage[4]%></small></h2>
                <div id="filespan" class="bs-sidebar">
                	<%=onpage[2]%>
                </div>
            </div>
        </div>
    </div>
</asp:Content>