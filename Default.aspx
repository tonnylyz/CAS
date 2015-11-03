<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="MasterPage.master" Title="十三班 - CAS" CodeFile="Default.aspx.cs" Inherits="CAS.Default" %>
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
                    <img src="http://cass.oss-cn-shenzhen.aliyuncs.com/img/slide1.jpg">
                    <div class="carousel-caption">
                        <h1>CAS 6.3</h1>
                        <p>全新版本的CAS将颠覆你对高中班级网站的想象！</p>
                    </div>
                </div>
                <div class="item">
                    <img src="http://cass.oss-cn-shenzhen.aliyuncs.com/img/slide2.jpg">
                    <div class="carousel-caption">
                        <h1>响应设计</h1>
                        <p>全新设计优化对平板、手机的支持。</p>
                    </div>
                </div>
                <div class="item">
                    <img src="http://cass.oss-cn-shenzhen.aliyuncs.com/img/slide3.jpg">
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
                <p class="bg-primary" style="padding:15px;">CAS纪念版上线。祝同学们在新学期里马到成功！</p>
            </div>
            <div class="col-md-4">
                <h2>相册 <small><a href="Gallery.aspx">更多</a></small></h2>
                <div>
                    <img class="img-responsive img-thumbnail" src="http://cass.oss-cn-shenzhen.aliyuncs.com/photo/5B20180E-34EF-43FD-B205-3ECC619B4AD5_thumb.jpg" />
                </div>
            </div>
            <div class="col-md-4">
                <h2>生日 <small><a href="Calendar.aspx">更多</a></small></h2>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>姓名</th>
                            <th>生日</th>
                        </tr>
                    </thead>
                    <tbody id="birthday">

                    </tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>