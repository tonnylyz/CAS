using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Personal : System.Web.UI.Page
{

    public string[] infoa = new string[] { "未能成功载入", "未能成功载入", "未能成功载入", "未能成功载入" };

    public string page_script = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UUID"] == null)
            Response.Redirect("Login.aspx");
    }

    private byte[] Crop(string Img, int Width, int Height, int X, int Y)
    {
        using (var OriginalImage = new Bitmap(Img))
        {
            using (var bmp = new Bitmap(Width, Height, OriginalImage.PixelFormat))
            {
                bmp.SetResolution(OriginalImage.HorizontalResolution, OriginalImage.VerticalResolution);
                using (Graphics Graphic = Graphics.FromImage(bmp))
                {
                    Graphic.SmoothingMode = SmoothingMode.AntiAlias;
                    Graphic.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    Graphic.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    Graphic.DrawImage(OriginalImage, new Rectangle(0, 0, Width, Height), X, Y, Width, Height, GraphicsUnit.Pixel);
                    var ms = new MemoryStream();
                    bmp.Save(ms, OriginalImage.RawFormat);
                    return ms.GetBuffer();
                }
            }
        }
    }

    private byte[] CropImage(string originaImgPath, int width, int height, int x, int y)
    {
        byte[] CropImage = Crop(originaImgPath, width, height, x, y);
        return CropImage;
    }
    public void MakeSmallImg(System.IO.Stream fromFileStream, string fileSaveUrl, System.Double templateWidth, System.Double templateHeight)
    {
        try
        {
            System.Drawing.Image myImage = System.Drawing.Image.FromStream(fromFileStream, true);
            System.Double newWidth = myImage.Width, newHeight = myImage.Height;
            if (myImage.Width > myImage.Height || myImage.Width == myImage.Height)
            {
                if (myImage.Width > templateWidth)
                {
                    newWidth = templateWidth;
                    newHeight = myImage.Height * (newWidth / myImage.Width);
                }
            }
            else
            {
                if (myImage.Height > templateHeight)
                {
                    newHeight = templateHeight;
                    newWidth = myImage.Width * (newHeight / myImage.Height);
                }
            }
            System.Drawing.Size mySize = new Size((int)newWidth, (int)newHeight);
            System.Drawing.Image bitmap = new System.Drawing.Bitmap(mySize.Width, mySize.Height);
            System.Drawing.Graphics g = System.Drawing.Graphics.FromImage(bitmap);
            g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
            g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
            g.Clear(Color.White);
            g.DrawImage(myImage, new System.Drawing.Rectangle(0, 0, bitmap.Width, bitmap.Height),
            new System.Drawing.Rectangle(0, 0, myImage.Width, myImage.Height),
            System.Drawing.GraphicsUnit.Pixel);

            bitmap.Save(fileSaveUrl, System.Drawing.Imaging.ImageFormat.Jpeg);
            g.Dispose();
            myImage.Dispose();
            bitmap.Dispose();
        }
        catch
        {

        }
    }
    protected void Savehead_Click(object sender, EventArgs e)
    {
        int x = int.Parse(Request["x"]);
        int y = int.Parse(Request["y"]);
        int w = int.Parse(Request["w"]);
        int h = int.Parse(Request["h"]);
        string filename = Session["tempimg"].ToString();
        byte[] image = CropImage(Server.MapPath("Photo") + "\\" + filename, w, h, x, y);
        Stream headstream = new MemoryStream(image);
        if (File.Exists(Server.MapPath("Photo") + "\\" + Session["realname"].ToString() + ".jpg"))
        {
            File.Delete(Server.MapPath("Photo") + "\\" + Session["realname"].ToString() + ".jpg");
        }
        MakeSmallImg(headstream, Server.MapPath("Photo") + "\\" + Session["realname"].ToString() + ".jpg", 80, 80);
        headstream.Close();
        if (File.Exists(Server.MapPath("Photo") + "\\"+filename))
        {
            File.Delete(Server.MapPath("Photo") + "\\"+filename);
        }
        page_script = @"Messenger().post({message: '" + "头像更改完成。若未改变，请清理缓存。" + "',showCloseButton: true});$('#Tab li:eq(1) a').tab('show');";
    }

}