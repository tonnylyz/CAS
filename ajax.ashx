<%@ WebHandler Language="C#" Class="ajax" %>
using System;
using System.Web;
using System.Data;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System.Web.SessionState;
using System.Drawing;
using System.Drawing.Drawing2D;

public class ajax : IHttpHandler, IRequiresSessionState
{
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
        if (Convert.ToInt32(CAS.sqlExecute("SELECT COUNT(*) FROM CAS_Homework WHERE date ='" + dt.ToShortDateString() + "' AND subject ='" + subject + "'")) != 0)
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
            SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sqlConnStr);
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
        if (Convert.ToInt32(CAS.sqlExecute("SELECT COUNT(*) FROM CAS_File WHERE date ='" + dt.ToShortDateString() + "' AND subject ='" + subject + "'")) != 0)
        {
            back = "<li>" + subject + "<ul class='nav'>";
            string cmd = "SELECT * FROM CAS_File WHERE date = '" + dt.ToShortDateString() + "' AND subject ='" + subject + "'";
            SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sqlConnStr);
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
        if (Convert.ToInt32(CAS.sqlExecute("SELECT COUNT(*) FROM CAS_File WHERE date ='" + dt.ToShortDateString() + "' AND subject ='" + subject + "'")) != 0)
        {
            back = "<li>" + subject + "<ul class='nav'>";
            string cmd = "SELECT * FROM CAS_File WHERE date = '" + dt.ToShortDateString() + "' AND subject ='" + subject + "'";
            SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sqlConnStr);
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
        SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM CAS_Notice WHERE date between '" + dt1.ToShortDateString() + "' and '" + dt2.ToShortDateString() + "'", CAS.sqlConnStr);
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
        SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM CAS_Notice WHERE date between '" + dt1.ToShortDateString() + "' and '" + dt2.ToShortDateString() + "' AND CONTAINS(title,@key) OR CONTAINS(info,@key)", CAS.sqlConnStr);
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
        catch
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
    

    delegate string lbds(string str);
    delegate bool lbdb(string b);
    delegate void lbdv(string b);
    delegate string lbdi(int b);

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        //LAMBDA FUNCTION
        lbds req = x =>
        {
            if (context.Request[x] != null) 
                return context.Request[x].ToString(); 
            else 
                return "";
        };
        lbds crf = x =>
        {
            if (context.Request.Form[x] != null)
                return context.Request.Form[x].ToString();
            else
                return "";
        };
        lbdb cfn = x => context.Request.Form[x] != null;
        lbdb rnn = x => context.Request[x] != null;
        lbds ses = x => context.Session[x].ToString();
        lbdb snn = x => context.Session[x] != null;
        lbdi per = x => ses("per").Split(',')[x];
        lbdb act = x => req("action").ToString() == x;
        lbdv crw = x => context.Response.Write(x);
        lbdb isg = x =>
        {
            try
            {
                Guid a = new Guid(x.ToString());
                return true;
            }
            catch
            {
                return false;
            }
        };
        
        //GLOBAL CONN
        SqlConnection conn = new SqlConnection(CAS.sqlConnStr);
        conn.Open();
        
        //RETURN
        string[] r_flag_s = { "success", "info", "error", "critical" };
        int r_flag = 0;
        string r_data = "";
        
        if (snn("UUID") && rnn("action"))
        {
            //gettalk(), get talk content
            if (act("gettalk"))
            {
                try
                {
                    r_data = CAS.sqlAdapter("SELECT CAS_Talk.*, CAS_User.* FROM CAS_talk, CAS_User WHERE [GUID] NOT IN (SELECT [TUID] FROM CAS_Talklog WHERE [UUID] = '" + ses("UUID") + "') AND CAS_User.[UUID] = CAS_Talk.[UUID] AND CAS_Talk.[classnum] = '"+ses("classnum")+"'",
                        new string[] { "GUID", "UUID", "name", "username", "date", "cont" });
                    r_flag = 0;
                }
                catch (Exception ex)
                {
                    CAS.log(ex);
                    r_flag = 3;
                }
            }
            //talkgood(TUID), praise a talk
            else if (act("talkgood") && rnn("TUID"))
            {
                //I think it should return something
                if (Convert.ToInt32(CAS.sqlExecute("SELECT COUNT(*) FROM CAS_Talklog WHERE TUID='" + req("TUID") + "' AND UUID='" + ses("UUID") + "'")) == 0)
                    CAS.sqlExecute("INSERT INTO CAS_Talklog (TUID, UUID, type) VALUES ('" + req("TUID") + "', '" + ses("UUID") + "', 1)");
                r_flag = 0;
            }
            //talkread(TUID), read a talk
            else if (act("talkread") && rnn("TUID"))
            {
                //I think it should return something
                if (Convert.ToInt32(CAS.sqlExecute("SELECT COUNT(*) FROM CAS_Talklog WHERE TUID='" + req("TUID") + "' AND UUID='" + ses("UUID") + "'")) == 0)
                    CAS.sqlExecute("INSERT INTO CAS_Talklog (TUID, UUID, type) VALUES ('" + req("TUID") + "', '" + ses("UUID") + "', 0)");
                r_flag = 0;
            }
            //logout(), global_logout()
            else if (act("logout"))
            {
                context.Session.Abandon();
                r_flag = 0;
                r_data = "{\"info\":\"" + "注销成功。" + "\"}";
            }
            //talksub(talksubct)
            else if (act("talksub") && cfn("talksubct"))
            {
                if (crf("talksubct").Length < 256 && crf("talksubct").Trim() != "")
                {
                    try
                    {
                        SqlCommand cmd = new SqlCommand("INSERT INTO CAS_Talk ([cont],  [UUID], [classnum]) VALUES (@cont, '" + ses("UUID") + "', '" + ses("classnum") + "')", conn);
                        SqlParameter para = new SqlParameter("@cont", SqlDbType.NVarChar, 255);
                        para.Value = crf("talksubct");
                        cmd.Parameters.Add(para);
                        cmd.ExecuteNonQuery();
                        r_flag = 0;
                    }
                    catch (Exception ex)
                    {
                        r_flag = 3;
                        CAS.log(ex);
                    }
                }
                else
                {
                    r_flag = 1;
                }
              
            }
            //gethistalk()
            else if (act("gethistalk"))
            {
                try
                {
                    r_flag = 0;
                    r_data = CAS.sqlAdapter("SELECT CAS_Talk.[cont], CAS_Talk.[date], CAS_User.[name], CAS_User.[UUID] FROM CAS_talk, CAS_User WHERE CAS_User.[UUID] = CAS_Talk.[UUID] AND CAS_Talk.[classnum] = '213' ORDER BY CAS_Talk.[date] DESC", new string[] { "name", "cont", "date", "UUID" });
                }
                catch (Exception ex)
                {
                    CAS.log(ex);
                    r_flag = 3;
                }
            }
            //getaddressbook()
            else if (act("getaddressbook"))
            {
                string back = "";
                string cmd = "SELECT * FROM CAS_User order by [name] collate Chinese_PRC_CS_AS_KS_WS";
                SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sqlConnStr);
                DataSet ds = new DataSet();
                da.Fill(ds);
                for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    back = back + "<div class=\"col-md-4 cardspan\"><div class=\"infocard\"><a onclick=\"addressbook_showinfo('" + ds.Tables[0].Rows[i]["UUID"].ToString() + "')\"><img src=\"Photo/" + ds.Tables[0].Rows[i]["name"].ToString() + ".jpg\" /><h4>" + ds.Tables[0].Rows[i]["name"].ToString() + " <small>@" + ds.Tables[0].Rows[i]["username"].ToString() + "</small></h4></a></div></div>";
                }
                crw(back);
            }
            //getaddressinfo(UUID) return {username, name, mail, QQ, birth, phone}
            else if (act("getaddressinfo") && context.Request["UUID"] != null)
            {
                string username = "", name = "", mail = "", QQ = "", birth = "", phone = "";
                SqlCommand cmd = new SqlCommand("SELECT * FROM CAS_User WHERE UUID=@UUID", conn);
                SqlParameter para = new SqlParameter("@UUID", SqlDbType.VarChar, 50);
                para.Value = context.Request["UUID"].ToString();
                cmd.Parameters.Add(para);
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
                    //maybe the birthday format or the null key may lead to an exception 
                }
                dr.Close();
                crw(username + "," + name + "," + mail + "," + QQ + "," + birth + "," + phone);
            }
            //calendarsub(info, iosta, ioend), add an event(content, start date, end date) if it is a one-day event the last two arguments is the same
            else if (act("calendarsub") && context.Request.Form["ioinfo"] != null && context.Request.Form["iosta"] != null && context.Request.Form["ioend"] != null && context.Session["per"].ToString().Split(',')[3] != "0")
            {
                DateTime dt = DateTime.Now;
                if (DateTime.TryParse(context.Request.Form["iosta"].ToString(), out dt) && DateTime.TryParse(context.Request.Form["ioend"].ToString(), out dt))
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO CAS_Calendar ([info], [sdate], [edate], [UUID]) VALUES (@info, @sdate, @edate, '" + ses("UUID") + "')", conn);
                    SqlParameter para = new SqlParameter("@info", SqlDbType.NVarChar, 255);
                    para.Value = context.Request.Form["ioinfo"].ToString();
                    cmd.Parameters.Add(para);
                    para = new SqlParameter("@sdate", SqlDbType.Date);
                    para.Value = context.Request.Form["iosta"].ToString();
                    cmd.Parameters.Add(para);
                    para = new SqlParameter("@edate", SqlDbType.Date);
                    para.Value = context.Request.Form["ioend"].ToString();
                    cmd.Parameters.Add(para);
                    cmd.ExecuteNonQuery();
                    crw("OK");
                }
            }
            //homeworksub(iocont), permission required(per[6] != 0)
            else if (act("homeworksub") && context.Request.Form["iocont"] != null && context.Session["per"].ToString().Split(',')[6] != "0")
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
                    //I can't bear such stupid naming method.
                }
                string[] str = context.Request.Form["iocont"].Split(',');
                if (IsOnlyNumber(str[0]))//Why did I use this unnecessary function
                {
                    for (int i = 1; i <= int.Parse(str[0]); i++)
                    {
                        if (str[i] != "")
                        {
                            SqlCommand cmd = new SqlCommand("INSERT INTO CAS_Homework (subject,info) VALUES ('" + subject + "',@info)", conn);
                            SqlParameter para = new SqlParameter("@info", SqlDbType.NVarChar, 255);
                            para.Value = i + ". " + str[i];
                            cmd.Parameters.Add(para);
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
                crw("OK");
            }
            else if (act("photosub") && context.Request["title"] != null && context.Session["per"].ToString().Split(',')[2] != "0")
            {
                SqlCommand cmd = new SqlCommand("INSERT INTO CAS_Photo (title, UUID) VALUES (@title, '" + ses("UUID") + "') SELECT @@IDENTITY AS returnName;", conn);
                SqlParameter para = new SqlParameter("@title", SqlDbType.NVarChar, 255);
                para.Value = context.Request["title"].ToString();
                cmd.Parameters.Add(para);

                string GUID = CAS.sqlExecute("SELECT GUID FROM CAS_Photo WHERE ID = " + cmd.ExecuteScalar()).ToString();
                HttpPostedFile file = context.Request.Files["iofile"];
                file.SaveAs(context.Server.MapPath("Photo") + "\\" + GUID + ".jpg");
                FileStream uppho = File.OpenRead(context.Server.MapPath("Photo") + "\\" + GUID + ".jpg");
                MakeSmallImg(uppho, context.Server.MapPath("Photo") + "\\" + GUID + "_thumb.jpg", 300, 169);

                //crw("OK");
            }
            else if (act("noticesub") && cfn("iotitle") && cfn("iocont") && per(4) != "0")
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO CAS_Notice ([title], [UUID], [info], [classnum]) VALUES (@title, '" + ses("UUID") + "', @info, '" + ses("classnum") + "')", conn);
                    SqlParameter para = new SqlParameter("@title", SqlDbType.NVarChar, 255);
                    para.Value = crf("iotitle");
                    cmd.Parameters.Add(para);
                    para = new SqlParameter("@info", SqlDbType.NText);
                    para.Value = System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(crf("iocont")));
                    cmd.Parameters.Add(para);
                    cmd.ExecuteNonQuery();
                    r_flag = 0;
                }
                catch (Exception ex)
                {
                    CAS.log(ex);
                    r_flag = 3;
                }
            }
        }
        //action login(username, password, class) Length: username [3,20], password [6,20], class 3
        if (act("login") && cfn("username") && cfn("password") && cfn("classnum"))
        {
            if (context.Session["error"] == null)
            {
                context.Session["error"] = 5;
                //Only 5 chances for a single browser session to verify the identification
            }
            
            string username = crf("username");
            string password = crf("password");
            string classnum = crf("classnum");
            
            string info = "";
            
            if (int.Parse(ses("error")) <= 0)
            {
                info = "系统拒绝服务，请重启浏览器后重试。";
                r_flag = 3;
            }
            else
            {
                if (username.Length > 20 || username.Length < 3 || password.Length > 20 || password.Length < 6 || classnum.Length != 3)
                {
                    info = "用户名、密码或班级长度不合法。";
                    r_flag = 1;
                }
                else
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM CAS_User WHERE [username] = @username AND [classnum] = @classnum", conn);
                    SqlParameter para = new SqlParameter("@username", SqlDbType.VarChar, 30);
                    para.Value = username.ToLower();
                    cmd.Parameters.Add(para);
                    para =new SqlParameter("@classnum", SqlDbType.VarChar, 3);
                    para.Value = classnum;
                    cmd.Parameters.Add(para);
                    try
                    {
                        SqlDataReader dr = cmd.ExecuteReader();
                        if (dr.Read())
                        {
                            if (dr["pwd"].ToString() == Encrypt(password))
                            {
                                context.Session["classnum"] = classnum;
                                context.Session["username"] = username.ToLower();
                                context.Session["realname"] = dr["name"].ToString();
                                context.Session["UUID"] = dr["UUID"].ToString();
                                context.Session["per"] = dr["permission"].ToString();
                                context.Session["error"] = 5;
                                info = "登陆成功。";
                                r_flag = 0;
                            }
                            else
                            {
                                info = "指定的密码与存储的密码无法匹配。";
                                context.Session["error"] = int.Parse(ses("error")) - 1;
                                r_flag = 2;
                            }
                        }
                        else
                        {
                            info = "指定的用户名不存在。";
                            context.Session["error"] = int.Parse(ses("error")) - 1;
                            r_flag = 2;
                        }
                        dr.Close();
                    }
                    catch (Exception ex)
                    {
                        CAS.log(ex);
                        info = "发生未预料的系统错误，请重启浏览器后重试。";
                        context.Session["error"] = int.Parse(ses("error")) - 5;
                        r_flag = 3;
                    }
                }
            }
            r_data = "{\"info\":\"" + info + "\"}";
        }
        else if (act("getbulletin") && rnn("searchkey"))
        {
            if (req("searchkey").Trim() == "")
            {
                r_flag = 1;
            }
            else
            {
                r_data = CAS.sqlAdapter("SELECT * FROM CAS_Notice WHERE [classnum] = '" + ses("classnum") + "' AND CONTAINS(title,@key) OR CONTAINS(info,@key)", new string[] { "title", "GUID" }, new SqlParameter[] { new SqlParameter("@key", req("searchkey")) });
                r_flag = 0;
            }
        }
        else if (act("getnotice") && rnn("GUID"))
        {
            string title = "";
            string cont = "";
            string user = "";
            string date = "";

            SqlCommand cmd = new SqlCommand("SELECT * FROM CAS_Notice WHERE [GUID] = @GUID", conn);
            SqlParameter para = new SqlParameter("@GUID", SqlDbType.VarChar, 50);
            para.Value = req("GUID");
            cmd.Parameters.Add(para);
            try
            {
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    title = dr["title"].ToString();
                    cont = dr["info"].ToString();
                    user = CAS.sqlExecute("SELECT [name] FROM CAS_User WHERE [UUID] = '" + dr["UUID"].ToString() + "'").ToString();
                    date = dr["date"].ToString();
                }
                dr.Close();
                r_flag = 0;
                r_data = "{\"title\":\"" + title + "\",\"cont\":\"" + Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(cont)) + "\",\"user\":\"" + user + "\",\"date\":\"" + date + "\"}";
            }
            catch (Exception ex)
            {
                CAS.log(ex);
                r_flag = 3;
            }
            
        }
        else if (act("gethomeworklist"))
        {
            string back = "";
            DateTime dt = DateTime.Now;
            if (context.Request["date"] == null)
            {
                dt = Convert.ToDateTime(CAS.sqlExecute("select date from CAS_Homework ORDER BY ID desc"));
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
            //crw(back);
        }
        else if (act("getnoticelist"))
        {
            string back = "";
            string cmd = "SELECT TOP 7 * FROM CAS_Notice ORDER BY ID DESC";
            SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sqlConnStr);
            DataSet ds = new DataSet();
            da.Fill(ds);
            for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                back = back + "<li><a href='Bulletin.aspx?ID=" + ds.Tables[0].Rows[i]["ID"].ToString() + "'>" + ds.Tables[0].Rows[i]["title"].ToString() + "<span class='badge pull-right'>" + Convert.ToDateTime(ds.Tables[0].Rows[i]["date"]).ToShortDateString() + "</span></a></li>";
            }
            //crw(back);
        }
        else if (act("getfilelist"))
        {
            string back = "";
            DateTime dt = DateTime.Now;
            if (context.Request["date"] == null)
            {
                dt = Convert.ToDateTime(CAS.sqlExecute("select date from CAS_File ORDER BY ID desc"));
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
            //crw(back);
        }
        else if (act("getfile") && context.Request["file"] != null)
        {
            string filename = "";
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
        else if (act("getcalendar") && context.Request["start"].ToString() != null && context.Request["end"].ToString() != null)
        {
            string eventback = "", birthback = "";
            string cmd = "SELECT * FROM CAS_Calendar WHERE [sdate] BETWEEN '" + CAS.dateToString(Convert.ToDateTime(context.Request["start"].ToString())) + "' AND '" + CAS.dateToString(Convert.ToDateTime(context.Request["end"].ToString())) + "' OR [edate] BETWEEN '" + Convert.ToDateTime(context.Request["start"].ToString()).ToShortDateString() + "' AND '" + Convert.ToDateTime(context.Request["end"].ToString()).ToShortDateString() + "'";
            SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sqlConnStr);
            DataSet ds = new DataSet();
            da.Fill(ds);
            for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                eventback = eventback + "{\"title\": \"" + ds.Tables[0].Rows[i]["info"].ToString().Replace("\"", "") + "\", \"start\": \"" + Convert.ToDateTime(ds.Tables[0].Rows[i]["sdate"].ToString()).ToShortDateString().Replace("/", "-") + "\", \"end\": \"" + Convert.ToDateTime(ds.Tables[0].Rows[i]["edate"].ToString()).ToShortDateString().Replace("/", "-") + "\"},";
            }
            string cmdb = "SELECT * FROM CAS_User";
            SqlDataAdapter dab = new SqlDataAdapter(cmdb, CAS.sqlConnStr);
            DataSet dsb = new DataSet();
            dab.Fill(dsb);
            for (var i = 0; i < dsb.Tables[0].Rows.Count; i++)
            {
                DateTime dt = DateTime.Now;
                if (DateTime.TryParse(dsb.Tables[0].Rows[i]["birthday"].ToString(), out dt))
                {
                    int r_year_s = Convert.ToDateTime(context.Request["start"].ToString()).Year;
                    int r_year_e = Convert.ToDateTime(context.Request["end"].ToString()).Year;
                    int r_mon_s = Convert.ToDateTime(context.Request["start"].ToString()).Month;
                    int r_mon_e = Convert.ToDateTime(context.Request["end"].ToString()).Month;
                    int r_day_s = Convert.ToDateTime(context.Request["start"].ToString()).Day;
                    int r_day_e = Convert.ToDateTime(context.Request["end"].ToString()).Day;

                    if (dt.Month <= r_mon_e && dt.Month >= r_mon_s && dt.Day <= r_day_e && dt.Day >= r_day_s)
                        if (r_year_s != r_year_e && dt.Month == 1)
                            birthback = birthback + "{\"title\": \"" + dsb.Tables[0].Rows[i]["name"].ToString() + "的生日\", \"start\": \"" + r_year_e + "-" + (Convert.ToDateTime(dsb.Tables[0].Rows[i]["birthday"].ToString()).Month).ToString() + "-" + Convert.ToDateTime(dsb.Tables[0].Rows[i]["birthday"].ToString()).Day + "\"},";
                        else
                            birthback = birthback + "{\"title\": \"" + dsb.Tables[0].Rows[i]["name"].ToString() + "的生日\", \"start\": \"" + r_year_s + "-" + (Convert.ToDateTime(dsb.Tables[0].Rows[i]["birthday"].ToString()).Month).ToString() + "-" + Convert.ToDateTime(dsb.Tables[0].Rows[i]["birthday"].ToString()).Day + "\"},";
                }
            }
            //crw(("[" + eventback + birthback + "]").Replace(",]", "]"));
        }
        conn.Close();
        crw("{\"flag\":\"" + r_flag_s[r_flag] + "\"" + ((r_data != "") ? (",\"data\":" + r_data) : "") + "}");
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}