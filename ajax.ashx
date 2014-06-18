<%@ WebHandler Language="C#" Class="ajax"%>
using System;
using System.Web;
using System.Data;
using System.IO;
using System.Data.SqlClient;
using System.Web.SessionState;
using System.Drawing;
using System.Drawing.Drawing2D;

public class ajax : IHttpHandler, IRequiresSessionState
{
    public static bool IsGuid(object o)
    {
        try
        {
            Guid a = new Guid(o.ToString());
            return true;
        }
        catch
        {
            return false;
        }
    }

    public bool IsChina(string CString)
    {
        for (int i = 0; i < CString.Length; i++)
        {
            if (Convert.ToInt32(Convert.ToChar(CString.Substring(i, 1))) >= Convert.ToInt32(Convert.ToChar(128)))
            {
                return true;
            }
        }
        return false;
    }
    public static bool IsOnlyNumber(string value)
    {
        System.Text.RegularExpressions.Regex r = new System.Text.RegularExpressions.Regex(@"^[0-9]+$");

        return r.Match(value).Success;
    }

    public string Gethomework(string subject, DateTime dt)
    {
        string back = "";
        if (Convert.ToInt32(CAS.sql_execute("SELECT COUNT(*) FROM CAS_Homework WHERE date ='" + dt.ToShortDateString() + "' AND subject ='" + subject + "'")) != 0)
        {
            switch (subject)
            {
                case "chi": back = "<li>语文<ul class='nav'>"; break;
                case "mat": back = "<li>数学<ul class='nav'>"; break;
                case "eng": back = "<li>英语<ul class='nav'>"; break;
                case "phy": back = "<li>物理<ul class='nav'>"; break;
                case "che": back = "<li>化学<ul class='nav'>"; break;
                case "bio": back = "<li>生物<ul class='nav'>"; break;
                case "pol": back = "<li>政治<ul class='nav'>"; break;
                case "his": back = "<li>历史<ul class='nav'>"; break;
                case "geo": back = "<li>地理<ul class='nav'>"; break;
            }
            string cmd = "SELECT * FROM CAS_Homework WHERE date = '" + dt.ToShortDateString() + "' AND subject ='" + subject + "'";
            SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sql_connstr);
            DataSet ds = new DataSet();
            da.Fill(ds);
            for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                back = back + "<li>" + ds.Tables[0].Rows[i]["info"].ToString() + "</li>";
            }
            back = back + "</ul><li>";
        }
        return back;
    }

    public string Getfilelist(string subject, DateTime dt)
    {
        string back = "";
        if (Convert.ToInt32(CAS.sql_execute("SELECT COUNT(*) FROM CAS_File WHERE date ='" + dt.ToShortDateString() + "' AND subject ='" + subject + "'")) != 0)
        {
            back = "<li>" + subject + "<ul class='nav'>";
            string cmd = "SELECT * FROM CAS_File WHERE date = '" + dt.ToShortDateString() + "' AND subject ='" + subject + "'";
            SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sql_connstr);
            DataSet ds = new DataSet();
            da.Fill(ds);
            for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                back = back + "<li><a href=\"ajax.ashx?action=getfile&file=" + ds.Tables[0].Rows[i]["path"].ToString() + "\">" + ds.Tables[0].Rows[i]["filename"].ToString() + "</a></li>";
            }
            back = back + "</ul><li>";
        }
        return back;
    }
    public string GetfilelistIn(string subject, DateTime dt)
    {
        string back = "";
        if (Convert.ToInt32(CAS.sql_execute("SELECT COUNT(*) FROM CAS_File WHERE date ='" + dt.ToShortDateString() + "' AND subject ='" + subject + "'")) != 0)
        {
            back = "<li>" + subject + "<ul class='nav'>";
            string cmd = "SELECT * FROM CAS_File WHERE date = '" + dt.ToShortDateString() + "' AND subject ='" + subject + "'";
            SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sql_connstr);
            DataSet ds = new DataSet();
            da.Fill(ds);
            for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                back = back + "<li><a onclick='filelib_selectfile(this)' id=\"" + ds.Tables[0].Rows[i]["path"].ToString() + "\">" + ds.Tables[0].Rows[i]["filename"].ToString() + "</a></li>";
            }
            back = back + "</ul><li>";
        }
        return back;
    }

    public string Getbulletinlist(DateTime dt1, DateTime dt2)
    {
        string back = "";
        SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM CAS_Notice WHERE date between '" + dt1.ToShortDateString() + "' and '" + dt2.ToShortDateString() + "'", CAS.sql_connstr);
        DataSet ds = new DataSet();
        da.Fill(ds);
        for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            back = "<li onclick=\"bulletin_shownotice('" + ds.Tables[0].Rows[i]["GUID"].ToString() + "');\" id='" + ds.Tables[0].Rows[i]["GUID"].ToString() + "'><a style='cursor:pointer'>" + ds.Tables[0].Rows[i]["title"].ToString() + "</a></li>" + back;
        }
        return back;
    }

    public string Getbulletinsearch(DateTime dt1, DateTime dt2, string key)
    {
        string back = "";
        SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM CAS_Notice WHERE date between '" + dt1.ToShortDateString() + "' and '" + dt2.ToShortDateString() + "' AND CONTAINS(title,@key) OR CONTAINS(info,@key)", CAS.sql_connstr);
        da.SelectCommand.Parameters.Add("@key", SqlDbType.NVarChar, 50);
        da.SelectCommand.Parameters[0].Value = key;
        DataSet ds = new DataSet();
        da.Fill(ds);
        for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            back = "<li onclick=\"bulletin_shownotice('" + ds.Tables[0].Rows[i]["GUID"].ToString() + "');\" id='" + ds.Tables[0].Rows[i]["GUID"].ToString() + "'><a style='cursor:pointer'>" + ds.Tables[0].Rows[i]["title"].ToString() + "</a></li>" + back;
        }
        return back;
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
        catch (Exception ex)
        {
		
        }
    }
    public string Encrypt(string strPwd)
    {
        System.Security.Cryptography.MD5 md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
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
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        if (context.Session["username"] != null)
        {
            if (context.Request["action"] != null && context.Request["action"].ToString() == "gettalk")
            {
                string back = "";
                string cmd = "SELECT CAS_Talk.*, CAS_User.* FROM CAS_talk, CAS_User WHERE date BETWEEN '" + DateTime.Now.AddMonths(-3).ToShortDateString() + "' AND '" + DateTime.Now.AddDays(1).ToShortDateString() + "' AND GUID NOT IN (SELECT TUID FROM CAS_Talklog WHERE UUID = '" + context.Session["UUID"] + "') AND CAS_User.UUID = CAS_Talk.UUID";
                SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sql_connstr);
                DataSet ds = new DataSet();
                da.Fill(ds);
                for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    back = back + "<div class='talkcard' ID='tc" + ds.Tables[0].Rows[i]["GUID"].ToString() + "'><div class='talkcardhead'><img id='userhead' src='Photo/" + ds.Tables[0].Rows[i]["name"].ToString() + ".jpg' height='40px' width='40px'></div><div class='talkcardinfo'><p class='talkoptitle'>" + ds.Tables[0].Rows[i]["name"].ToString() + "@" + ds.Tables[0].Rows[i]["username"].ToString() + "</p><p class='talkoptitlerd'><a onclick=\"talk_read('" + ds.Tables[0].Rows[i]["GUID"].ToString() + "')\">×</a> | <a onclick=\"talk_good('" + ds.Tables[0].Rows[i]["GUID"].ToString() + "')\">赞</a></p></div><div class='talkcardtime'>" + Convert.ToDateTime(ds.Tables[0].Rows[i]["date"]).GetDateTimeFormats('f')[0].ToString() + "</div><div class='talkcardcontent'>" + ds.Tables[0].Rows[i]["cont"].ToString() + "</div></div>";
                }
                context.Response.Write(back);
            }
            else if (context.Request["action"] != null && context.Request["action"].ToString() == "talkgood" && context.Request["TUID"] != null && IsGuid(context.Request["TUID"].ToString()))
            {
                string TUID = context.Request["TUID"].ToString();
                if (Convert.ToInt32(CAS.sql_execute("SELECT COUNT(*) FROM CAS_Talklog WHERE TUID='" + TUID + "' AND UUID='" + context.Session["UUID"].ToString() + "'")) == 0)
                {
                    CAS.sql_execute("INSERT INTO CAS_Talklog (TUID, UUID, type) VALUES ('" + TUID + "', '" + context.Session["UUID"].ToString() + "', 1)");
                }
            }
            else if (context.Request["action"] != null && context.Request["action"].ToString() == "talkread" && context.Request["TUID"] != null && IsGuid(context.Request["TUID"].ToString()))
            {
                string TUID = context.Request["TUID"].ToString();
                if (Convert.ToInt32(CAS.sql_execute("SELECT COUNT(*) FROM CAS_Talklog WHERE TUID='" + TUID + "' AND UUID='" + context.Session["UUID"].ToString() + "'")) == 0)
                {
                    CAS.sql_execute("INSERT INTO CAS_Talklog (TUID, UUID, type) VALUES ('" + TUID + "', '" + context.Session["UUID"].ToString() + "', 0)");
                }
            }
            else if (context.Request["action"] != null && context.Request["action"].ToString() == "logincheck")
            {
                context.Response.Write("success,"+context.Session["UUID"].ToString());
            }
            else if (context.Request["action"] != null && context.Request["action"].ToString() == "userinfo" && context.Request["UUID"] != null)
            {
                context.Response.Write("success," + context.Session["username"].ToString() + "," + context.Session["realname"].ToString() + "," + context.Session["per"].ToString().Replace(",","-"));
            }
            else if (context.Request["action"] != null && context.Request["action"].ToString() == "logout")
            {
                context.Session.Abandon();
            }
            else if (context.Request["action"] != null && context.Request["action"].ToString() == "talksub" && context.Request.Form["talksubct"] != null && context.Request.Form["talksubct"].ToString().Length < 256)
            {
                string cont = context.Request.Form["talksubct"].ToString();
                SqlConnection conn = new SqlConnection(CAS.sql_connstr);
                SqlCommand cmd = new SqlCommand("INSERT INTO CAS_Talk (cont, type, UUID) VALUES (@cont, 'talk', '" + context.Session["UUID"].ToString() + "')", conn);
                SqlParameter para = new SqlParameter("@cont", SqlDbType.NVarChar, 255);
                para.Value = cont;
                cmd.Parameters.Add(para);
                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    context.Response.Write("OK");
                }
                catch
                {
                    
                }
                finally
                {
                    conn.Close();
                }
            }
            else if (context.Request["action"] != null && context.Request["action"].ToString() == "gethistalk")
            {
                string back = "";
                string cmd = "SELECT CAS_Talk.*, CAS_User.* FROM CAS_talk, CAS_User WHERE CAS_User.UUID = CAS_Talk.UUID ORDER BY CAS_Talk.ID DESC";
                SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sql_connstr);
                DataSet ds = new DataSet();
                da.Fill(ds);
                for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    back = back + "<div><img style='float:left;margin:5px' src=\"Photo/" + ds.Tables[0].Rows[i]["name"].ToString() + ".jpg\" height=\"40px\" width=\"40px\"/><h4 style='float:left;padding-top:10px'>" + ds.Tables[0].Rows[i]["name"].ToString() + "：</h4><p style='clear:both'>" + ds.Tables[0].Rows[i]["cont"].ToString() + "</p><p style='text-align:right;color:#ccc;'>" + Convert.ToDateTime(ds.Tables[0].Rows[i]["date"]).GetDateTimeFormats('f')[0].ToString() + "<br>赞" + CAS.sql_execute("SELECT COUNT (*) FROM CAS_Talklog WHERE TUID ='" + ds.Tables[0].Rows[i]["GUID"].ToString() + "' AND type = 1").ToString() + "</p></div><hr>";
                }
                context.Response.Write(back);
            }
            else if (context.Request["action"] != null && context.Request["action"].ToString() == "getaddressbook")
            {
                string back = "";
                string cmd = "SELECT * FROM CAS_User order by [name] collate Chinese_PRC_CS_AS_KS_WS";
                SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sql_connstr);
                DataSet ds = new DataSet();
                da.Fill(ds);
                for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    back = back + "<div class=\"col-md-4 cardspan\"><div class=\"infocard\"><a onclick=\"addressbook_showinfo('" + ds.Tables[0].Rows[i]["UUID"].ToString() + "')\"><img src=\"Photo/" + ds.Tables[0].Rows[i]["name"].ToString() + ".jpg\" /><h4>" + ds.Tables[0].Rows[i]["name"].ToString() + " <small>@" + ds.Tables[0].Rows[i]["username"].ToString() + "</small></h4></a></div></div>";
                }
                context.Response.Write(back);
            }
            else if (context.Request["action"] != null && context.Request["action"].ToString() == "getaddressinfo" && context.Request["UUID"]!= null)
            {
                string username = "";
                string name = "";
                string mail = "";
                string QQ = "";
                string birth = "";
                string phone = "";

                SqlConnection conn = new SqlConnection(CAS.sql_connstr);
                SqlCommand cmd = new SqlCommand("SELECT * FROM CAS_User WHERE UUID=@UUID",conn);
                SqlParameter para = new SqlParameter("@UUID", SqlDbType.VarChar, 50);
                para.Value = context.Request["UUID"].ToString();
                cmd.Parameters.Add(para);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                try
                {
                    while (dr.Read())
                    {
                        username = dr["username"].ToString();
                        name = dr["name"].ToString();
                        mail = dr["mail"].ToString();
                        QQ = dr["QQ"].ToString();
                        phone = dr["phone"].ToString();
                        birth = Convert.ToDateTime(dr["birthday"].ToString()).ToLongDateString();
                    }
                }
                catch
                {
                    
                }
                dr.Close();
                conn.Close();
                context.Response.Write(username+","+name+","+mail+","+QQ+","+birth+","+phone);
            }
            else if (context.Request["action"] != null && context.Request["action"].ToString() == "calendarsub" && context.Request.Form["ioinfo"] != null && context.Request.Form["iosta"] != null && context.Request.Form["ioend"] != null && context.Session["per"].ToString().Split(',')[3] != "0")
            {
                DateTime dt = DateTime.Now;
                if (DateTime.TryParse(context.Request.Form["iosta"].ToString(), out dt) && DateTime.TryParse(context.Request.Form["ioend"].ToString(), out dt))
                {
                    SqlConnection conn = new SqlConnection(CAS.sql_connstr);
                    SqlCommand cmd = new SqlCommand("INSERT INTO CAS_Calendar (info, sdate, edate, UUID) VALUES (@info, '" + context.Request.Form["iosta"].ToString() + "', '" + context.Request.Form["ioend"].ToString() + "', '" + context.Session["UUID"].ToString() + "')", conn);
                    SqlParameter para1 = new SqlParameter("@info", SqlDbType.NVarChar, 255);
                    para1.Value = context.Request.Form["ioinfo"].ToString();
                    cmd.Parameters.Add(para1);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                    context.Response.Write("OK");
                }
            }
            else if (context.Request["action"] != null && context.Request["action"].ToString() == "homeworksub" && context.Request.Form["iocont"] != null && context.Session["per"].ToString().Split(',')[6] != "0")
            {
                string subject = "";
                switch (context.Session["per"].ToString().Split(',')[6])
                {
                    case "1": subject = "chi"; break;
                    case "2": subject = "mat"; break;
                    case "3": subject = "eng"; break;
                    case "4": subject = "phy"; break;
                    case "5": subject = "che"; break;
                    case "6": subject = "bio"; break;
                    case "7": subject = "pol"; break;
                    case "8": subject = "his"; break;
                    case "9": subject = "geo"; break;
                }
                string[] str = context.Request.Form["iocont"].Split(',');
                if (IsOnlyNumber(str[0]))
                {
                    for (int i = 1; i <= int.Parse(str[0]); i++)
                    {
                        if (str[i] != "")
                        {
                            SqlConnection conn = new SqlConnection(CAS.sql_connstr);
                            SqlCommand cmd = new SqlCommand("INSERT INTO CAS_Homework (subject,info) VALUES ('" + subject + "',@info)", conn);
                            SqlParameter para = new SqlParameter("@info", SqlDbType.NVarChar, 255);
                            para.Value = i + ". " + str[i];
                            cmd.Parameters.Add(para);
                            conn.Open();
                            cmd.ExecuteNonQuery();
                            conn.Close();
                        }
                    }
                }
                context.Response.Write("OK");
            }
            else if (context.Request["action"] != null && context.Request["action"].ToString() == "photosub" && context.Request["title"] != null && context.Session["per"].ToString().Split(',')[2] != "0")
            {
                SqlConnection conn = new SqlConnection(CAS.sql_connstr);
                SqlCommand cmd = new SqlCommand("INSERT INTO CAS_Photo (title, UUID) VALUES (@title, '" + context.Session["UUID"].ToString() + "') SELECT @@IDENTITY AS returnName;", conn);
                SqlParameter para = new SqlParameter("@title", SqlDbType.NVarChar, 255);
                para.Value = context.Request["title"].ToString();
                cmd.Parameters.Add(para);

                conn.Open();
                string GUID = CAS.sql_execute("SELECT GUID FROM CAS_Photo WHERE ID = " + cmd.ExecuteScalar()).ToString();
                conn.Close();
                HttpPostedFile file = context.Request.Files["iofile"];
                file.SaveAs(context.Server.MapPath("Photo") + "\\" + GUID + ".jpg");
                FileStream uppho = File.OpenRead(context.Server.MapPath("Photo") + "\\" + GUID + ".jpg");
                MakeSmallImg(uppho, context.Server.MapPath("Photo") + "\\" + GUID + "_thumb.jpg", 300, 169);

                context.Response.Write("OK");
            }
            else if (context.Request["action"] != null && context.Request["action"].ToString() == "noticesub" && context.Request.Form["iotitle"] != null && context.Request.Form["iocont"] != null && context.Session["per"].ToString().Split(',')[4] != "0")
            {
                SqlConnection conn = new SqlConnection(CAS.sql_connstr);
                SqlCommand cmd = new SqlCommand("INSERT INTO CAS_Notice (title, UUID, info) VALUES (@title, '" + context.Session["UUID"].ToString() + "', @info)", conn);
                SqlParameter para1 = new SqlParameter("@title", SqlDbType.NVarChar, 255);
                para1.Value = context.Request["iotitle"].ToString();
                cmd.Parameters.Add(para1);
                SqlParameter para2 = new SqlParameter("@info", SqlDbType.NText);
                para2.Value = context.Request["iocont"].ToString();
                cmd.Parameters.Add(para2);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
                context.Response.Write("OK");
            }
        }
        if (context.Request["action"] != null && context.Request["action"].ToString() == "login" && context.Request.Form["username"] != null && context.Request.Form["password"] != null && context.Session["username"] == null)
        {
            if (context.Session["error"] == null)
            {
                context.Session["error"] = 5;
            }
            string username = context.Request.Form["username"].ToString();
            string password = context.Request.Form["password"].ToString();
            string LoginLabel = "";
            if (!(username.Length > 20 || password.Length > 20))
            {

                if (int.Parse(context.Session["error"].ToString()) <= 0)
                {
                    LoginLabel = "错误ID：0x800F040；细节：系统拒绝服务，请重启浏览器后重试。";
                }
                else
                {
                    if (context.Request.Form["username"].ToString() == "" || context.Request.Form["password"].ToString() == "")
                    {
                        LoginLabel = "错误ID：0x800B040；细节：用户名或密码不为空，请重试。";
                    }
                    else
                    {
                        SqlConnection conn = new SqlConnection(CAS.sql_connstr);
                        SqlCommand cmd = new SqlCommand("select * from CAS_User where username=@username", conn);
                        SqlParameter para = new SqlParameter("@username", SqlDbType.VarChar, 30);
                        para.Value = username.ToLower();
                        cmd.Parameters.Add(para);
                        try
                        {
                            conn.Open();
                            SqlDataReader dr = cmd.ExecuteReader();
                            if (dr.Read())
                            {
                                if (dr["pwd"].ToString() == Encrypt(password))
                                {
                                    context.Session["username"] = dr["username"].ToString();
                                    context.Session["realname"] = dr["name"].ToString();
                                    context.Session["UUID"] = dr["UUID"].ToString();
                                    context.Session["per"] = dr["permission"].ToString();
                                    context.Session["error"] = 10;
                                    LoginLabel = "OK";
                                }
                                else
                                {
                                    LoginLabel = "错误ID：0x800W040；细节：指定的密码与存储的密码无法匹配，请重试。";
                                    context.Session["error"] = int.Parse(context.Session["error"].ToString()) - 1;
                                }
                            }
                            else
                            {
                                LoginLabel = "错误ID：0x800E040；细节：指定的用户名不存在，请重试。";
                                context.Session["error"] = int.Parse(context.Session["error"].ToString()) - 1;
                            }
                            dr.Close();
                        }
                        catch
                        {
                            LoginLabel = "错误ID：0x800U040；细节：发生未预料的系统错误。";
                            context.Session["error"] = int.Parse(context.Session["error"].ToString()) - 10;
                        }
                        finally
                        {
                            conn.Close();
                        }
                    }
                }
            }
            else
            {
                LoginLabel = "错误ID：0x800L040；细节：过长的用户名或密码。";
                context.Session["error"] = int.Parse(context.Session["error"].ToString()) - 1;
            }
            context.Response.Write(LoginLabel);
        }
        else if (context.Request["action"] != null && context.Request["action"].ToString() == "getbulletin" && context.Request["searchkey"] == null)
        {
            context.Response.Write("<li class='nav-header'>近一月</li>");
            string a1 = Getbulletinlist(new DateTime(DateTime.Now.Year, DateTime.Now.Month - 1, DateTime.Now.Day), DateTime.Now.AddDays(1));
            if (a1 == "")
            {
                context.Response.Write("<li>暂无</li>");
            }
            else
            {
                context.Response.Write(a1);
            }
            context.Response.Write("<li class='nav-header'>近三月</li>");
            string a2 = Getbulletinlist(new DateTime(DateTime.Now.Year, DateTime.Now.Month - 3, DateTime.Now.Day), new DateTime(DateTime.Now.Year, DateTime.Now.Month - 1, DateTime.Now.Day+1));
            if (a2 == "")
            {
                context.Response.Write("<li>无</li>");
            }
            else
            {
                context.Response.Write(a2);
            }
        }
        else if (context.Request["action"] != null && context.Request["action"].ToString() == "getbulletin" && context.Request["searchkey"] != null)
        {
            if (context.Request["searchkey"].ToString() == "")
            {
                context.Response.Write("<li>无</li>");
            }
            else
            {
                string a1 = Getbulletinsearch(DateTime.Now.AddMonths(-6), DateTime.Now.AddMonths(12), context.Request["searchkey"].ToString());
                if (a1 == "")
                {
                    context.Response.Write("<li>无</li>");
                }
                else
                {
                    context.Response.Write(a1);
                    context.Response.Write("<li class='divider'></li><li><a href=\"Bulletin.aspx\">返回</a></li>");
                }
            }
        }
        else if (context.Request["action"] != null && context.Request["action"].ToString() == "getnoticeguid" && context.Request["ID"] != null)
        {
            if (IsOnlyNumber(context.Request["ID"].ToString()))
            {
                context.Response.Write(CAS.sql_execute("SELECT GUID FROM CAS_Notice WHERE ID =" + context.Request["ID"].ToString()));
            }
        }
        else if (context.Request["action"] != null && context.Request["action"].ToString() == "getnotice" && context.Request["GUID"] != null)
        {
            string title = "";
            string cont = "";
            string type = "";
            string date = "";
            int ID = 0;

            SqlConnection conn = new SqlConnection(CAS.sql_connstr);
            SqlCommand cmd = new SqlCommand("SELECT * FROM CAS_Notice WHERE GUID = @GUID", conn);
            SqlParameter para1 = new SqlParameter("@GUID", SqlDbType.VarChar, 50);
            para1.Value = context.Request["GUID"].ToString();
            cmd.Parameters.Add(para1);
            try
            {
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    ID = Convert.ToInt32(dr["ID"].ToString());
                    title = dr["title"].ToString();
                    cont = dr["info"].ToString();
                    type = CAS.sql_execute("SELECT name FROM CAS_User WHERE UUID = '"+dr["UUID"].ToString()+"'").ToString();
                    date = dr["date"].ToString();
                }
                dr.Close();
            }
            catch
            {

            }
            finally
            {
                conn.Close();
            }
            context.Response.Write(title + "}{" + type + "}{" + date + "}{" + cont);
        }
        else if (context.Request["action"] != null && context.Request["action"].ToString() == "gethomeworklist")
        {
            string back = "";
            DateTime dt = DateTime.Now;
            if (context.Request["date"] == null)
            {
                dt = Convert.ToDateTime(CAS.sql_execute("select date from CAS_Homework ORDER BY ID desc"));
            }
            else
            {
                dt = Convert.ToDateTime(context.Request["date"].ToString());
            }
            string[] subject = new string[] { "chi", "mat", "eng", "phy", "che", "bio", "pol", "his", "geo" };
            foreach (string sub in subject)
            {
                back = back + Gethomework(sub, dt);
            }
            context.Response.Write(back);
        }
        else if (context.Request["action"] != null && context.Request["action"].ToString() == "getnoticelist")
        {
            string back = "";
            string cmd = "SELECT TOP 7 * FROM CAS_Notice ORDER BY ID DESC";
            SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sql_connstr);
            DataSet ds = new DataSet();
            da.Fill(ds);
            for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                back = back + "<li><a href='Bulletin.aspx?ID=" + ds.Tables[0].Rows[i]["ID"].ToString() + "'>" + ds.Tables[0].Rows[i]["title"].ToString() + "<span class='badge pull-right'>" + Convert.ToDateTime(ds.Tables[0].Rows[i]["date"]).ToShortDateString() + "</span></a></li>";
            }
            context.Response.Write(back);
        }
		else if (context.Request["action"] != null && context.Request["action"].ToString() == "getfilelist")
        {
            string back = "";
            DateTime dt = DateTime.Now;
            if (context.Request["date"] == null)
            {
                dt = Convert.ToDateTime(CAS.sql_execute("select date from CAS_File ORDER BY ID desc"));
            }
			else
			{
				dt = Convert.ToDateTime(context.Request["date"].ToString());
			}
            string[] subject = new string[] { "语文", "数学", "英语", "物理", "化学", "生物", "政治", "历史", "地理" };
            foreach (string sub in subject)
            {
				if (context.Request["date"] == null)
				{
					back = back + Getfilelist(sub, dt);
				}
				else
				{
					back = back + GetfilelistIn(sub, dt);
				}
            }
            context.Response.Write(back);
		}
        else if (context.Request["action"] != null && context.Request["action"].ToString() == "getfile" && context.Request["file"] != null)
        {
            string filename = "";
            SqlConnection conn = new SqlConnection(CAS.sql_connstr);
            SqlCommand cmd = new SqlCommand("SELECT [filename] FROM CAS_File WHERE path=@path", conn);
            SqlParameter para = new SqlParameter("@path", SqlDbType.NVarChar, 50);
            para.Value = context.Request["file"].ToString();
            cmd.Parameters.Add(para);
            conn.Open();
            object back = cmd.ExecuteScalar();
            if (back != null && !Convert.IsDBNull(back))
                filename = back.ToString();
            conn.Close();
            string path = context.Server.MapPath("Doc/" + context.Request["file"].ToString());
            if (File.Exists(path) && filename != "")
            {
                context.Response.ContentType = "application/octet-stream";
                if (context.Request.UserAgent.ToLower().IndexOf("trident") > -1)
                {
                    filename = CAS.ToHexString(filename);
                }
                if (context.Request.UserAgent.ToLower().IndexOf("firefox") > -1)
                {
                    context.Response.AddHeader("Content-Disposition", "attachment;filename=\"" + filename + "\"");
                }
                else 
                    context.Response.AddHeader("Content-Disposition", "attachment;filename=" + filename);
                context.Response.WriteFile(path);
                context.Response.End();
            }
            
                
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}