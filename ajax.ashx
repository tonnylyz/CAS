<%@ WebHandler Language="C#" Class="CAS.Ajax" %>
using System;
using System.Web;
using System.Data;
using System.IO;
using System.Web.SessionState;
namespace CAS
{
    public class Ajax : IHttpHandler, IRequiresSessionState
    {
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
            SqlIntegrate si = new SqlIntegrate(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());

            //RETURN
            string[] r_flag_s = { "success", "info", "error", "critical" };
            int r_flag = 3;
            string r_data = "";

            if (rnn("action"))
            {
                //gettalk(), get talk content
                if (act("gettalk"))
                {
                    try
                    {
                        r_data = si.AdapterJSON(
                            "SELECT CAS_Talk.*, CAS_User.* FROM CAS_Talk, CAS_User WHERE GUID NOT IN (SELECT TUID FROM CAS_Talklog WHERE UUID = '" + ses("UUID") + "') AND CAS_User.UUID = CAS_Talk.UUID",
                            new string[] { "GUID", "UUID", "name", "username", "date", "cont" }
                        );
                        r_flag = 0;
                    }
                    catch (Exception ex)
                    {
                        Utility.log(ex);
                        r_flag = 3;
                    }
                }
                //talkgood(TUID), praise a talk
                else if (act("talkgood") && rnn("TUID"))
                {
                    if (Convert.ToInt32(si.Query("SELECT COUNT(*) FROM CAS_Talklog WHERE TUID='" + req("TUID") + "' AND UUID='" + ses("UUID") + "'")) == 0)
                        si.Execute("INSERT INTO CAS_Talklog (TUID, UUID, type) VALUES ('" + req("TUID") + "', '" + ses("UUID") + "', 1)");
                    r_flag = 0;
                }
                //talkread(TUID), read a talk
                else if (act("talkread") && rnn("TUID"))
                {
                    if (Convert.ToInt32(si.Query("SELECT COUNT(*) FROM CAS_Talklog WHERE TUID='" + req("TUID") + "' AND UUID='" + ses("UUID") + "'")) == 0)
                        si.Execute("INSERT INTO CAS_Talklog (TUID, UUID, type) VALUES ('" + req("TUID") + "', '" + ses("UUID") + "', 0)");
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
                            si.InitParameter(1);
                            si.AddParameter("@cont", "Text", crf("talksubct"));
                            si.Execute("INSERT INTO CAS_Talk (GUID, cont, UUID) VALUES ('" + System.Guid.NewGuid() + "', @cont, '" + ses("UUID") + "')");
                            r_flag = 0;
                        }
                        catch (Exception ex)
                        {
                            Utility.log(ex);
                            r_flag = 3;
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
                        r_data = si.AdapterJSON("SELECT CAS_Talk.cont, CAS_Talk.date, CAS_User.name, CAS_User.UUID FROM CAS_Talk, CAS_User WHERE CAS_User.UUID = CAS_Talk.UUID ORDER BY CAS_Talk.date DESC"
                            , new string[] { "name", "cont", "date", "UUID" });
                    }
                    catch (Exception ex)
                    {
                        Utility.log(ex);
                        r_flag = 3;
                    }
                }
                //getaddressbook() return [{UUID, name, username}, ... ]
                else if (act("getaddressbook"))
                {
                    try
                    {
                        r_flag = 0;
                        r_data = si.AdapterJSON("SELECT * FROM CAS_User ORDER BY convert(name USING gbk) COLLATE gbk_chinese_ci"
                            , new string[] { "UUID", "name", "username" });
                    }
                    catch (Exception ex)
                    {
                        Utility.log(ex);
                        r_flag = 3;
                    }
                }
                //getaddressinfo(UUID) return {username, name, mail, QQ, phone, birthday}
                else if (act("getaddressinfo") && rnn("UUID") && isg(req("UUID")))
                {
                    try
                    {
                        r_data = si.QueryJSON("SELECT * FROM CAS_User WHERE UUID='" + req("UUID") + "'"
                            , new string[] { "username", "name", "mail", "QQ", "phone", "birthday" });
                        r_flag = 0;
                    }
                    catch (Exception ex)
                    {
                        Utility.log(ex);
                        r_flag = 3;
                    }
                }
                //getinfo() return {mail,QQ,phone,birthday}
                else if (act("getinfo"))
                {
                    try
                    {
                        r_data = si.QueryJSON("SELECT * FROM CAS_User WHERE UUID='" + ses("UUID") + "'"
                            , new string[] { "mail", "QQ", "phone", "birthday", "university" }).Replace(" 0:00:00", "").Replace("/", "-");
                        r_flag = 0;
                    }
                    catch (Exception ex)
                    {
                        Utility.log(ex);
                        r_flag = 3;
                    }
                }
                else if (act("infosub"))
                {
                    try
                    {
                        si.InitParameter(5);
                        si.AddParameter("@QQ", "VarChar", crf("QQ"), 50);
                        si.AddParameter("@mail", "VarChar", crf("mail"), 50);
                        si.AddParameter("@phone", "VarChar", crf("phone"), 50);
                        si.AddParameter("@birthday", "Date", crf("birthday"));
                        si.AddParameter("@university", "VarChar", crf("university"), 50);
                        si.Execute("UPDATE CAS_User SET QQ = @QQ, mail = @mail, phone = @phone, birthday = @birthday, university = @university WHERE UUID = '" + ses("UUID") + "'");
                        r_flag = 0;
                    }
                    catch (Exception ex)
                    {
                        Utility.log(ex);
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
                            if (Utility.encrypt(crf("password")) == si.Query("SELECT pwd FROM CAS_User WHERE UUID ='" + ses("UUID") + "'"))
                            {
                                si.Execute("UPDATE CAS_User SET pwd = '" + Utility.encrypt(crf("passwordn")) + "' WHERE UUID = '" + ses("UUID") + "'");
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
                        Utility.log(ex);
                        r_flag = 3;
                    }
                }
                else if (act("cropsub") && cfn("x") && cfn("y") && cfn("w") && cfn("h"))
                {
                    try
                    {
                        CAS.Utility.cropImage(context.Server.MapPath("photo") + "/c_" + ses("avatarpath")
                            , context.Server.MapPath("photo") + "/" + ses("UUID") + ".jpg"
                            , int.Parse(crf("x"))
                            , int.Parse(crf("y"))
                            , int.Parse(crf("w"))
                            , int.Parse(crf("h")));
                        r_flag = 0;
                    }
                    catch (Exception ex)
                    {
                        Utility.log(ex);
                        r_flag = 3;
                    }
                }
                //calendarsub(info, iosta, ioend), add an event(content, start date, end date) if it is a one-day event the last two arguments is the same
                else if (act("calendarsub") && cfn("ioinfo") && cfn("iosta") && cfn("ioend") && per(3) != "0")
                {
                    DateTime dt;
                    if (DateTime.TryParse(crf("iosta"), out dt) && DateTime.TryParse(crf("ioend"), out dt))
                    {
                        si.InitParameter(3);
                        si.AddParameter("@info", "VarChar", crf("ioinfo"), 50);
                        si.AddParameter("@sdate", "Date", crf("iosta"));
                        si.AddParameter("@edate", "Date", crf("ioend"));
                        si.Execute("INSERT INTO CAS_Calendar (GUID, info, sdate, edate, UUID) VALUES ('" + System.Guid.NewGuid() + "', @info, @sdate, @edate, '" + ses("UUID") + "')");
                        r_flag = 0;
                    }
                    else
                        r_flag = 1;
                }
                else if (act("photosub") && rnn("title") && context.Session["per"].ToString().Split(',')[2] != "0")
                {
                    try
                    {
                        string GUID = System.Guid.NewGuid().ToString();
                        si.InitParameter(1);
                        si.AddParameter("@title", "VarChar", req("title"), 50);
                        si.Execute("INSERT INTO CAS_Photo (GUID, title, UUID) VALUES ('" + GUID + "', @title, '" + ses("UUID") + "')");
                        HttpPostedFile file = context.Request.Files["iofile"];
                        file.SaveAs(context.Server.MapPath("photo") + "/" + GUID + ".jpg");
                        FileStream uppho = File.OpenRead(context.Server.MapPath("photo") + "/" + GUID + ".jpg");
                        Utility.makeSmallImg(uppho, context.Server.MapPath("photo") + "/" + GUID + "_thumb.jpg", 300, 169);
                        r_flag = 0;
                    }
                    catch (Exception ex)
                    {
                        Utility.log(ex);
                        r_flag = 3;
                    }
                }
                else if (act("avatarsub"))
                {
                    try
                    {
                        HttpPostedFile fileu = context.Request.Files["iofile"];
                        string name = ses("UUID") + "_" + DateTime.Now.ToString("HHmmssfff") + ".jpg";
                        fileu.SaveAs(context.Server.MapPath("photo") + "/" + name);
                        Stream uppho = new FileStream(context.Server.MapPath("photo") + "/" + name, FileMode.Open);
                        Utility.makeSmallImg(uppho, context.Server.MapPath("photo") + "/c_" + name, 700, 700);
                        uppho.Close();
                        FileInfo file = new FileInfo(context.Server.MapPath("photo") + "/" + name);
                        file.Delete();
                        context.Session["avatarpath"] = name;
                        r_data = "{\"ipath\":\"" + name + "\"}";
                        r_flag = 0;
                    }
                    catch (Exception ex)
                    {
                        Utility.log(ex);
                        r_flag = 3;
                    }
                }
                else if (act("noticesub") && cfn("iotitle") && cfn("iocont") && per(4) != "0")
                {
                    try
                    {
                        si.InitParameter(2);
                        si.AddParameter("@title", "VarChar", crf("iotitle"), 50);
                        si.AddParameter("@info", "Text", System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(crf("iocont"))));
                        si.Execute("INSERT INTO CAS_Notice (GUID, title, UUID, info) VALUES ('" + System.Guid.NewGuid() + "', @title, '" + ses("UUID") + "', @info)");
                        r_flag = 0;
                    }
                    catch (Exception ex)
                    {
                        Utility.log(ex);
                        r_flag = 3;
                    }
                }

                else if (act("getcalendar"))
                {

                    try
                    {
                        string eventtext = "", birthtext = "";
                        string[,] eventlist = si.Adapter("SELECT * FROM CAS_Calendar"
                            , new string[] { "info", "sdate", "edate" });
                        for (int i = 0; i < eventlist.GetLength(0); i++)
                            eventtext += "{\"title\": \"" + eventlist[i, 0].Replace("\"", "") + "\", \"startstr\": \"" + Utility.dateToString(eventlist[i, 1]) + "\", \"endstr\": \"" + Utility.dateToString(eventlist[i, 2]) + "\"},";
                        string[,] birthlist = si.Adapter("SELECT * FROM CAS_User"
                            , new string[] { "name", "birthday" });
                        for (int i = 0; i < birthlist.GetLength(0); i++)
                        {
                            DateTime dt;
                            if (DateTime.TryParse(birthlist[i, 1], out dt))
                            {
                                birthtext += "{\"title\": \"" + birthlist[i, 0] + "的生日\", \"startstr\": \"" + DateTime.Now.Year.ToString() + "-" + dt.Month.ToString() + "-" + dt.Day.ToString() + "\"},";
                                birthtext += "{\"title\": \"" + birthlist[i, 0] + "的生日\", \"startstr\": \"" + (DateTime.Now.Year + 1) + "-" + dt.Month.ToString() + "-" + dt.Day.ToString() + "\"},";
                            }
                        }
                        r_data = (("[" + eventtext + birthtext + "]").Replace(",]", "]"));
                        r_flag = 0;
                    }
                    catch (Exception ex)
                    {
                        Utility.log(ex);
                        r_flag = 3;
                    }
                }
                else if (act("getearth"))
                {
                    string earthtext = "[";
                    string[,] earthlist = si.Adapter("SELECT DISTINCT university FROM CAS_User"
                        , new string[] { "university" });
                    for (int i = 0; i < earthlist.Length; i++)
                    {
                        if (earthlist[i, 0] != "")
                        {
                            earthtext += "{\"university\":\"" + earthlist[i, 0] + "\",";
                            earthtext += " \"student\": [";
                            si.InitParameter(1);
                            Utility.log(earthlist[i, 0]);
                            si.AddParameter("@university", "VarChar", earthlist[i, 0], 50);
                            string[,] userlist = si.Adapter("SELECT * FROM CAS_User WHERE university = @university"
                                , new string[] { "name", "UUID" });
                            for (int j = 0; j < userlist.Length / 2; j++)
                            {
                                earthtext += "{\"name\":\"" + userlist[j, 0] + "\",\"UUID\":\"" + userlist[j, 1] + "\"},";
                            }
                            earthtext += "]},";
                        }
                    }
                    earthtext += "]";
                    r_data = earthtext.Replace(",]", "]").Replace(",}", "}");
                    r_flag = 0;
                }
                else if (act("getnotice") && rnn("GUID") && isg(req("GUID")))
                {
                    try
                    {
                        string[] notice = si.Query("SELECT * FROM CAS_Notice WHERE GUID = '" + req("GUID") + "'"
                            , new string[] { "title", "info", "UUID", "date" });
                        r_data = "{\"title\":\"" + notice[0] + "\",\"cont\":\"" + Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(notice[1])) + "\",\"user\":\"" + si.Query("SELECT [name] FROM CAS_User WHERE [UUID] = '" + notice[2] + "'") + "\",\"date\":\"" + Utility.dateToString(notice[3]) + "\"}";
                        r_flag = 0;
                    }
                    catch (Exception ex)
                    {
                        Utility.log(ex);
                        r_flag = 3;
                    }
                }
                else if (act("getbirthday"))
                {
                    try
                    {
                        r_data = si.AdapterJSON("SELECT * FROM CAS_User WHERE DATE_ADD(birthday, INTERVAL (extract(YEAR FROM NOW()) - extract(YEAR FROM birthday)) YEAR) BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 30 DAY) ORDER BY birthday ASC"
                            , new string[] { "name", "birthday" }).Replace(" 0:00:00", "");
                        r_flag = 0;
                    }
                    catch (Exception ex)
                    {
                        Utility.log(ex);
                        r_flag = 3;
                    }
                }
            }
            //action login(username, password) Length: username [3,20], password [6,20]
            if (act("login") && cfn("username") && cfn("password"))
            {
                if (context.Session["error"] == null)
                    context.Session["error"] = 5;
                //Only 5 chances for a single browser session to verify the identification
                string username = crf("username");
                string password = crf("password");
                string info = "";
                if (int.Parse(ses("error")) <= 0)
                {
                    info = "系统拒绝服务，请重启浏览器后重试。";
                    r_flag = 3;
                }
                else
                {
                    if (username.Length > 20 || username.Length < 3 || password.Length > 20 || password.Length < 6)
                    {
                        info = "用户名、密码长度不合法。";
                        r_flag = 1;
                    }
                    else
                    {
                        try
                        {
                            si.InitParameter(1);
                            si.AddParameter("@username", "VarChar", username.ToLower(), 50);
                            string[] user = si.Query("SELECT * FROM CAS_User WHERE username = @username AND pwd = '" + Utility.encrypt(password) + "'"
                                , new string[] { "username", "name", "UUID", "permission" });
                            if (user[0] != null)
                            {
                                context.Session["username"] = user[0];
                                context.Session["realname"] = user[1];
                                context.Session["UUID"] = user[2];
                                context.Session["per"] = user[3];
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
                        catch (Exception ex)
                        {
                            Utility.log(ex);
                            info = "发生未预料的系统错误，请重启浏览器后重试。";
                            context.Session["error"] = int.Parse(ses("error")) - 5;
                            r_flag = 3;
                        }
                    }
                }
                r_data = "{\"info\":\"" + info + "\"}";
            }

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
}