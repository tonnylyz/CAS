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
    public string getHomework(int subject, DateTime dt)
    {
        string back = "";
        if (Convert.ToInt32(CAS.sqlExecute("SELECT COUNT(*) FROM CAS_Homework WHERE [date] ='" + CAS.dateToString(dt) + "' AND [subject] =" + subject + " AND [classnum] = '" + HttpContext.Current.Session["classnum"].ToString() + "'")) != 0)
        {
            back = "<li>" + CAS.subject[subject] + "<ul class='nav'>";
            string cmd = "SELECT * FROM CAS_Homework WHERE [date] = '" + CAS.dateToString(dt) + "' AND [subject] =" + subject + " AND [classnum] = '" + HttpContext.Current.Session["classnum"].ToString() + "' ORDER BY [date] DESC";
            SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sqlConnStr);
            DataSet ds = new DataSet();
            da.Fill(ds);
            for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                back += "<li>" + ds.Tables[0].Rows[i]["info"].ToString() + "</li>";
            }
            back += "</ul><li>";
        }
        return back;
    }

    public string getFileList(int subject, DateTime dt)
    {
        string back = "";
        if (Convert.ToInt32(CAS.sqlExecute("SELECT COUNT(*) FROM CAS_File WHERE [date] ='" + CAS.dateToString(dt) + "' AND [subject] =" + subject + " AND [classnum]= '" + HttpContext.Current.Session["classnum"].ToString() + "'")) != 0)
        {
            back = "<li>" + CAS.subject[subject] + "<ul class='nav'>";
            string cmd = "SELECT * FROM CAS_File WHERE date = '" + CAS.dateToString(dt) + "' AND [subject] =" + subject + " AND [classnum]= '" + HttpContext.Current.Session["classnum"].ToString() + "'";
            SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sqlConnStr);
            DataSet ds = new DataSet();
            da.Fill(ds);
            for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                back = back + "<li><a onclick=\"fileLibSelectFile(this)\" data-path=\"" + ds.Tables[0].Rows[i]["GUID"].ToString() + "\">" + ds.Tables[0].Rows[i]["filename"].ToString() + "</a></li>";
            }
            back = back + "</ul><li>";
        }
        return back;
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
                    r_data = CAS.sqlAdapter(
                        "SELECT CAS_Talk.*, CAS_User.* FROM CAS_talk, CAS_User WHERE [GUID] NOT IN (SELECT [TUID] FROM CAS_Talklog WHERE [UUID] = '" + ses("UUID") + "') AND CAS_User.[UUID] = CAS_Talk.[UUID] AND CAS_Talk.[classnum] = '" + ses("classnum") + "'",
                        new string[] { "GUID", "UUID", "name", "username", "date", "cont" }
                    );
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
            //logout()
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
                    r_data = CAS.sqlAdapter("SELECT CAS_Talk.[cont], CAS_Talk.[date], CAS_User.[name], CAS_User.[UUID] FROM CAS_talk, CAS_User WHERE CAS_User.[UUID] = CAS_Talk.[UUID] AND CAS_Talk.[classnum] = '" + ses("classnum") + "' ORDER BY CAS_Talk.[date] DESC", new string[] { "name", "cont", "date", "UUID" });
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
                try
                {
                    r_flag = 0;
                    r_data = CAS.sqlAdapter("SELECT * FROM CAS_User WHERE [classnum] = '" + ses("classnum") + "' ORDER BY [name] collate Chinese_PRC_CS_AS_KS_WS", new string[] { "UUID", "name", "username" });
                }
                catch (Exception ex)
                {
                    CAS.log(ex);
                    r_flag = 3;
                }
            }
            //getaddressinfo(UUID) return {username, name, mail, QQ, birth, phone}
            else if (act("getaddressinfo") && rnn("UUID"))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM CAS_User WHERE [UUID]=@UUID", conn);
                SqlParameter para = new SqlParameter("@UUID", SqlDbType.VarChar, 50);
                para.Value = req("UUID");
                cmd.Parameters.Add(para);
                try
                {
                    SqlDataReader dr = cmd.ExecuteReader();
                    while (dr.Read())
                    {
                        r_data = "{\"username\":\"" + dr["username"].ToString() + "\",\"name\":\"" + dr["name"].ToString() + "\",\"mail\":\"" + dr["mail"].ToString() + "\",\"QQ\":\"" + dr["QQ"].ToString() + "\",\"phone\":\"" + dr["phone"].ToString() + "\",\"birthday\":\"" + dr["birthday"].ToString() + "\"}";
                    }
                    r_flag = 0;
                    dr.Close();
                }
                catch (Exception ex)
                {
                    CAS.log(ex);
                    r_flag = 3;
                }
            }
            else if (act("getinfo"))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM CAS_User WHERE [UUID]='" + ses("UUID") + "'", conn);
                try
                {
                    SqlDataReader dr = cmd.ExecuteReader();
                    while (dr.Read())
                    {
                        r_data = "{\"mail\":\"" + dr["mail"].ToString() + "\",\"QQ\":\"" + dr["QQ"].ToString() + "\",\"phone\":\"" + dr["phone"].ToString() + "\",\"birthday\":\"" + dr["birthday"].ToString().Replace(" 0:00:00", "") + "\"}";
                    }
                    r_flag = 0;
                    dr.Close();
                }
                catch (Exception ex)
                {
                    CAS.log(ex);
                    r_flag = 3;
                }
            }
            else if (act("infosub"))
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("UPDATE CAS_User SET [QQ] = @QQ, [mail] = @mail, [phone] = @phone, [birthday] = @birthday WHERE [UUID] = '" + ses("UUID") + "'", conn);
                    SqlParameter para = new SqlParameter("@QQ", SqlDbType.NVarChar, 50); ;
                    para.Value = crf("QQ");
                    cmd.Parameters.Add(para);
                    para = new SqlParameter("@mail", SqlDbType.NVarChar, 50); ;
                    para.Value = crf("mail");
                    cmd.Parameters.Add(para);
                    para = new SqlParameter("@phone", SqlDbType.NVarChar, 50); ;
                    para.Value = crf("phone");
                    cmd.Parameters.Add(para);
                    para = new SqlParameter("@birthday", SqlDbType.Date); ;
                    para.Value = Convert.ToDateTime(crf("birthday"));
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
            else if (act("passwordsub") && cfn("password") && cfn("passwordn"))
            {
                try
                {
                    if (crf("passwordn").Length < 6 || crf("passwordn").Length > 20)
                    {
                        r_flag = 1;
                    }
                    else
                    {
                        if (CAS.encrypt(crf("password")) == CAS.sqlExecute("SELECT [pwd] FROM CAS_User WHERE [UUID] ='" + ses("UUID") + "'"))
                        {
                            CAS.sqlExecute("UPDATE CAS_User SET [pwd] = '" + CAS.encrypt(crf("passwordn")) + "' WHERE [UUID] = '" + ses("UUID") + "'");
                            r_flag = 0;
                        }
                        else
                        {
                            r_flag = 2;
                        }
                    }
                }
                catch (Exception ex)
                {
                    CAS.log(ex);
                    r_flag = 3;
                }
            }
            else if (act("cropsub") && cfn("x") && cfn("y") && cfn("w") && cfn("h"))
            {
                try
                {
                    string original = context.Server.MapPath("Photo") + "\\c_" + ses("avatarpath");
                    string storage = context.Server.MapPath("Photo") + "\\" + ses("UUID") + ".jpg";
                    int x = int.Parse(crf("x")), y = int.Parse(crf("y")), w = int.Parse(crf("w")), h = int.Parse(crf("h"));
                    var OriginalImage = new Bitmap(original);
                    var bmp = new Bitmap(w, h, OriginalImage.PixelFormat);
                    bmp.SetResolution(OriginalImage.HorizontalResolution, OriginalImage.VerticalResolution);
                    Graphics Graphic = Graphics.FromImage(bmp);
                    Graphic.SmoothingMode = SmoothingMode.AntiAlias;
                    Graphic.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    Graphic.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    Graphic.DrawImage(OriginalImage, new Rectangle(0, 0, w, h), x, y, w, h, GraphicsUnit.Pixel);
                    var ms = new MemoryStream();
                    bmp.Save(ms, OriginalImage.RawFormat);
                    if (File.Exists(storage))
                    {
                        File.Delete(storage);
                    }
                    CAS.makeSmallImg(ms, storage, 80, 80);
                    ms.Close();
                    r_flag = 0;
                }
                catch (Exception ex)
                {
                    CAS.log(ex);
                    r_flag = 3;
                }
            }
            //calendarsub(info, iosta, ioend), add an event(content, start date, end date) if it is a one-day event the last two arguments is the same
            else if (act("calendarsub") && cfn("ioinfo") && cfn("iosta") && cfn("ioend") && per(3) != "0")
            {
                DateTime dt;
                if (DateTime.TryParse(crf("iosta"), out dt) && DateTime.TryParse(crf("ioend"), out dt))
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO CAS_Calendar ([info], [sdate], [edate], [UUID], [classnum]) VALUES (@info, @sdate, @edate, '" + ses("UUID") + "', '" + ses("classnum") + "')", conn);
                    SqlParameter para = new SqlParameter("@info", SqlDbType.NVarChar, 255);
                    para.Value = crf("ioinfo");
                    cmd.Parameters.Add(para);
                    para = new SqlParameter("@sdate", SqlDbType.Date);
                    para.Value = crf("iosta");
                    cmd.Parameters.Add(para);
                    para = new SqlParameter("@edate", SqlDbType.Date);
                    para.Value = crf("ioend");
                    cmd.Parameters.Add(para);
                    cmd.ExecuteNonQuery();
                    r_flag = 0;
                }
                else
                    r_flag = 1;
            }
            //homeworksub(iocont), permission required(per[6] != 0)
            else if (act("homeworksub") && cfn("iocont") && per(6) != "0")
            {
                try
                {
                    int subject = int.Parse(per(6)) - 1;
                    string[] str = crf("iocont").Split(',');
                    for (int i = 1; i <= int.Parse(str[0]); i++)
                    {
                        if (str[i] != "")
                        {
                            SqlCommand cmd = new SqlCommand("INSERT INTO CAS_Homework ([subject], [info], [classnum]) VALUES (" + subject + ", @info, '" + ses("classnum") + "')", conn);
                            SqlParameter para = new SqlParameter("@info", SqlDbType.NText);
                            para.Value = i + ". " + str[i];
                            cmd.Parameters.Add(para);
                            cmd.ExecuteNonQuery();
                        }
                    }
                    r_flag = 0;
                }
                catch (Exception ex)
                {
                    CAS.log(ex);
                    r_flag = 3;
                }
            }
            else if (act("photosub") && rnn("title") && context.Session["per"].ToString().Split(',')[2] != "0")
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO CAS_Photo ([title], [UUID], [classnum]) VALUES (@title, '" + ses("UUID") + "', '" + ses("classnum") + "') SELECT @@IDENTITY AS returnName;", conn);
                    SqlParameter para = new SqlParameter("@title", SqlDbType.NVarChar, 255);
                    para.Value = context.Request["title"].ToString();
                    cmd.Parameters.Add(para);

                    string GUID = CAS.sqlExecute("SELECT [GUID] FROM CAS_Photo WHERE ID = " + cmd.ExecuteScalar()).ToString();
                    HttpPostedFile file = context.Request.Files["iofile"];
                    file.SaveAs(context.Server.MapPath("Photo") + "\\" + GUID + ".jpg");
                    FileStream uppho = File.OpenRead(context.Server.MapPath("Photo") + "\\" + GUID + ".jpg");
                    CAS.makeSmallImg(uppho, context.Server.MapPath("Photo") + "\\" + GUID + "_thumb.jpg", 300, 169);
                    r_flag = 0;
                }
                catch (Exception ex)
                {
                    CAS.log(ex);
                    r_flag = 3;
                }
            }
            else if (act("avatarsub"))
            {
                try
                {
                    HttpPostedFile fileu = context.Request.Files["iofile"];
                    string name = ses("UUID") + "_" + DateTime.Now.ToString("HHmmssfff") + ".jpg";
                    fileu.SaveAs(context.Server.MapPath("Photo") + "\\" + name);
                    Stream uppho = new FileStream(context.Server.MapPath("Photo") + "\\" + name, FileMode.Open);
                    CAS.makeSmallImg(uppho, context.Server.MapPath("Photo") + "\\c_" + name, 700, 700);
                    uppho.Close();
                    FileInfo file = new FileInfo(context.Server.MapPath("Photo") + "\\" + name);
                    file.Delete();
                    context.Session["avatarpath"] = name;
                    r_data = "{\"ipath\":\"" + name + "\"}";
                    r_flag = 0;
                }
                catch (Exception ex)
                {
                    CAS.log(ex);
                    r_flag = 3;
                }
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

            else if (act("getcalendar"))
            {
                string eventback = "", birthback = "";
                string cmd = "SELECT * FROM CAS_Calendar WHERE [classnum] = '" + ses("classnum") + "'";
                SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sqlConnStr);
                DataSet ds = new DataSet();
                da.Fill(ds);
                for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    DateTime dt1 = Convert.ToDateTime(ds.Tables[0].Rows[i]["sdate"].ToString());
                    DateTime dt2 = Convert.ToDateTime(ds.Tables[0].Rows[i]["edate"].ToString());
                    eventback = eventback + "{\"title\": \"" + ds.Tables[0].Rows[i]["info"].ToString().Replace("\"", "") + "\", \"startstr\": \"" + CAS.dateToString(dt1) + "\", \"endstr\": \"" + CAS.dateToString(dt2) + "\"},";
                }
                string cmdb = "SELECT * FROM CAS_User WHERE [classnum] = '" + ses("classnum") + "'";
                SqlDataAdapter dab = new SqlDataAdapter(cmdb, CAS.sqlConnStr);
                DataSet dsb = new DataSet();
                dab.Fill(dsb);
                for (var i = 0; i < dsb.Tables[0].Rows.Count; i++)
                {
                    DateTime dt = DateTime.Now;
                    if (DateTime.TryParse(dsb.Tables[0].Rows[i]["birthday"].ToString(), out dt))
                    {
                        birthback += "{\"title\": \"" + dsb.Tables[0].Rows[i]["name"].ToString() + "的生日\", \"startstr\": \"" + DateTime.Now.Year.ToString() + "-" + dt.Month.ToString() + "-" + dt.Day.ToString() + "\"},";
                        birthback += "{\"title\": \"" + dsb.Tables[0].Rows[i]["name"].ToString() + "的生日\", \"startstr\": \"" + (DateTime.Now.Year + 1).ToString() + "-" + dt.Month.ToString() + "-" + dt.Day.ToString() + "\"},";
                    }
                }
                r_data = (("[" + eventback + birthback + "]").Replace(",]", "]"));
            }
            else if (act("getbulletin") && rnn("searchkey"))
            {
                if (req("searchkey").Trim() == "")
                {
                    r_flag = 1;
                }
                else
                {
                    try
                    {
                        r_data = CAS.sqlAdapter("SELECT * FROM CAS_Notice WHERE [classnum] = '" + ses("classnum") + "' AND CONTAINS(title,@key) OR CONTAINS(info,@key)", new string[] { "title", "GUID" }, new SqlParameter[] { new SqlParameter("@key", req("searchkey")) });
                        r_flag = 0;
                    }
                    catch (Exception ex)
                    {
                        CAS.log(ex);
                        r_flag = 3;
                    }
                }
            }
            else if (act("getnotice") && rnn("GUID"))
            {

                SqlCommand cmd = new SqlCommand("SELECT * FROM CAS_Notice WHERE [GUID] = @GUID", conn);
                SqlParameter para = new SqlParameter("@GUID", SqlDbType.VarChar, 50);
                para.Value = req("GUID");
                cmd.Parameters.Add(para);
                try
                {
                    string title = "";
                    string cont = "";
                    string user = "";
                    string date = "";
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
                try
                {
                    string back = "";
                    DateTime dt;
                    dt = Convert.ToDateTime(req("date"));
                    for (int sub = 0; sub < 9; sub++)
                        back = back + getHomework(sub, dt);
                    r_data = "{\"html\":\"" + Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(back)) + "\"}";
                    r_flag = 0;
                }
                catch (Exception ex)
                {
                    CAS.log(ex);
                    r_flag = 3;
                }
            }
            else if (act("getfilelist"))
            {
                try
                {
                    string back = "";
                    DateTime dt = Convert.ToDateTime(context.Request["date"].ToString());
                    for (int sub = 0; sub < 9; sub++)
                        back = back + getFileList(sub, dt);
                    r_data = "{\"html\":\"" + Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(back)) + "\"}";
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
                    para = new SqlParameter("@classnum", SqlDbType.VarChar, 3);
                    para.Value = classnum;
                    cmd.Parameters.Add(para);
                    try
                    {
                        SqlDataReader dr = cmd.ExecuteReader();
                        if (dr.Read())
                        {
                            if (dr["pwd"].ToString() == CAS.encrypt(password))
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