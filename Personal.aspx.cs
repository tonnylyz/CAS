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
        loadinfo();
    }

    public void loadinfo()
    {
        try
        {
            string QQinfo = "";
            string mailinfo = "";
            string phoneinfo = "";
            string birthdayinfo = "";
            SqlConnection conn = new SqlConnection(CAS.sql_connstr);
            SqlCommand cmd = new SqlCommand("SELECT * FROM CAS_User Where UUID='" + Session["UUID"].ToString() + "'", conn);
            conn.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                QQinfo = dr["QQ"].ToString();
                mailinfo = dr["mail"].ToString();
                phoneinfo = dr["phone"].ToString();
                birthdayinfo = Convert.ToDateTime(dr["birthday"].ToString()).ToShortDateString();
            }
            dr.Close();
            conn.Close();
            infoa = new string[] { QQinfo, mailinfo, phoneinfo, birthdayinfo };
        }
        catch
        {
        }
    }
    public string Encrypt(string strPwd)
    {
        MD5 md5 = new MD5CryptoServiceProvider();
        byte[] data = System.Text.Encoding.Default.GetBytes(strPwd);
        byte[] md5data = md5.ComputeHash(data);
        md5.Clear();
        string str = "";
        for (int i = 0; i < md5data.Length - 1; i++)
        {
            str += md5data[i].ToString("X").PadLeft(2, '0');
        }
        return str;
    }

    protected void UploadHead_Click(object sender, EventArgs e)
    {
        if (FileHead.PostedFile.FileName != "")
        {
            string name = Session["UUID"].ToString() + "_"+DateTime.Now.ToString("HHmmssfff")+".jpg";
            Session["tempimg"] = "c_" + name;
            string ipath = Server.MapPath("Photo") + "\\" + name;
            try
            {
                if (File.Exists(ipath))
                {
                    File.Delete(ipath);
                }
                FileHead.SaveAs(ipath);
                Stream uppho = new FileStream(ipath, FileMode.Open);
                MakeSmallImg(uppho, Server.MapPath("Photo") + "\\c_" + name, 700, 700);
                uppho.Close();
                FileInfo file = new FileInfo(ipath);
                file.Delete();
                page_script = @"Messenger().post({message: '" + "操作完成，照片上传成功，请进行裁切。" + "',showCloseButton: true});$('#Tab li:eq(1) a').tab('show');";
            }
            catch
            {
                page_script = @"Messenger().post({message: '" + "操作失败，文件无法读取。" + "',type: 'error',showCloseButton: true});$('#Tab li:eq(1) a').tab('show');";
            }
        }
        else
        {
            page_script = @"Messenger().post({message: '" + "操作失败，未选中文件。" + "',type: 'error',showCloseButton: true});$('#Tab li:eq(1) a').tab('show');";
        }

    }
    protected void changepwd_Click(object sender, EventArgs e)
    {
        if (newpwd.Text.Length < 6 || newpwd.Text.Length > 20)
        {
            page_script = @"Messenger().post({message: '" + "错误ID：0x800l030；细节：密码长度不符合要求，请重试。" + "',type: 'error',showCloseButton: true});$('#Tab li:eq(2) a').tab('show');";
        }
        else
        {
            SqlConnection conn = new SqlConnection(CAS.sql_connstr);
            SqlCommand cmd = new SqlCommand("SELECT pwd FROM CAS_User WHERE username ='" + Session["username"] + "'", conn);
            conn.Open();
            string oldpwd = cmd.ExecuteScalar().ToString();
            conn.Close();
            if (Encrypt(opwd.Text) == oldpwd)
            {
                if (newpwd.Text == rnpwd.Text)
                {
                    SqlConnection conn2 = new SqlConnection(CAS.sql_connstr);
                    SqlCommand cmd2 = new SqlCommand("Update CAS_User SET pwd = @pwd where username = '" + Session["username"] + "'", conn2);
                    SqlParameter para1 = new SqlParameter("@pwd", SqlDbType.NVarChar, 30);
                    para1.Value = Encrypt(rnpwd.Text);
                    cmd2.Parameters.Add(para1);
                    conn2.Open();
                    cmd2.ExecuteNonQuery();
                    conn2.Close();
                    page_script = @"Messenger().post({message: '" + "操作完成，更改密码成功。" + "',showCloseButton: true});$('#Tab li:eq(2) a').tab('show');";
                }
                else
                {
                    page_script = @"Messenger().post({message: '" + "错误ID：0x800p030；细节：两次密码键入不一致。" + "',type: 'error',showCloseButton: true});$('#Tab li:eq(2) a').tab('show');";
                }
            }
            else
            {
                page_script = @"Messenger().post({message: '" + "错误ID：0x800w030；细节：键入的密码未能与原密码匹配。" + "',type: 'error',showCloseButton: true});$('#Tab li:eq(2) a').tab('show');";
            }
        }
    }

    protected void Updateinfo_Click(object sender, EventArgs e)
    {
        try
        {
            SqlConnection conn2 = new SqlConnection(CAS.sql_connstr);
            SqlCommand cmd2 = new SqlCommand("Update CAS_User SET QQ = @QQ, mail = @mail, phone = @phone, birthday = @birthday where username = '" + Session["username"].ToString() + "'", conn2);
            SqlParameter para1 = new SqlParameter("@QQ", SqlDbType.NVarChar, 50);
            para1.Value = QQ.Text;
            SqlParameter para2 = new SqlParameter("@mail", SqlDbType.NVarChar, 50);
            para2.Value = mail.Text;
            SqlParameter para3 = new SqlParameter("@phone", SqlDbType.NVarChar, 50);
            para3.Value = phone.Text;
            SqlParameter para4 = new SqlParameter("@birthday", SqlDbType.Date);
            para4.Value = Convert.ToDateTime(birthday.Text);
            cmd2.Parameters.Add(para1);
            cmd2.Parameters.Add(para2);
            cmd2.Parameters.Add(para3);
            cmd2.Parameters.Add(para4);
            conn2.Open();
            cmd2.ExecuteScalar();
            conn2.Close();
            loadinfo();
            page_script = @"Messenger().post({message: '" + "操作完成，资料更改成功。" + "',showCloseButton: true});$('#Tab li:eq(0) a').tab('show');";

        }
        catch
        {
            page_script = @"Messenger().post({message: '" + "错误ID：0x800w030；细节：请检查您的输入并重试。" + "',type: 'error',showCloseButton: true});$('#Tab li:eq(0) a').tab('show');";
        }
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