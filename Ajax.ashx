<%@ WebHandler Language="C#" Class="Ajax" %>
using System;
using System.Web;
using System.Web.SessionState;
using System.Data;
using System.Text;
using System.IO;
using System.Drawing;
using System.Drawing.Drawing2D;

public class Ajax : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        //RETURN
        string[] r_flag_s = { "success", "info", "error", "critical" };
        int r_flag = 2;
        string r_data = "";

        if (context.Request["cat"] != null && context.Request["do"] != null)
            switch (context.Request["cat"])
            {
                case "user":
                    {
                        if (context.Request["do"] == "register")
                        {
                            try
                            {
                                CAS.SqlIntegrate si = new CAS.SqlIntegrate(CAS.Utility.connStr);
                                si.InitParameter(1);
                                si.AddParameter("@username", CAS.SqlIntegrate.DataType.VarChar, context.Request.Form["username"], 8);
                                if (Convert.ToInt32(si.Query("SELECT COUNT(*) FROM CAS_User WHERE username = @username")) == 0)
                                {
                                    si.InitParameter(9);
                                    si.AddParameter("@username", CAS.SqlIntegrate.DataType.VarChar, context.Request.Form["username"], 50);
                                    si.AddParameter("@realname", CAS.SqlIntegrate.DataType.NVarChar, context.Request.Form["realname"], 10);
                                    si.AddParameter("@SN", CAS.SqlIntegrate.DataType.VarChar, context.Request.Form["SN"], 8);
                                    si.AddParameter("@password", CAS.SqlIntegrate.DataType.VarChar, CAS.Utility.Encrypt(context.Request.Form["password"]), 50);
                                    si.AddParameter("@birthday", CAS.SqlIntegrate.DataType.Date, context.Request.Form["birthday"]);
                                    si.AddParameter("@QQ", CAS.SqlIntegrate.DataType.VarChar, context.Request.Form["QQ"], 20);
                                    si.AddParameter("@mail", CAS.SqlIntegrate.DataType.VarChar, context.Request.Form["mail"], 50);
                                    si.AddParameter("@phone", CAS.SqlIntegrate.DataType.VarChar, context.Request.Form["phone"], 50);
                                    si.AddParameter("@intro", CAS.SqlIntegrate.DataType.NVarChar, context.Request.Form["intro"], 255);
                                    si.Execute("UPDATE CAS_User SET username = @username, pwd = @password, birthday = @birthday, QQ = @QQ, mail = @mail, phone = @phone, intro = @intro  WHERE name = @realname AND SN = @SN AND pwd IS NULL");
                                    new CAS.User(context.Request.Form["username"]).Login(context.Request.Form["password"]);
                                    context.Session["firsttime"] = true;
                                    r_flag = 0;
                                }
                                else
                                    r_flag = 2;
                            }
                            catch (Exception ex)
                            {
                                CAS.Utility.Log(ex);
                                r_flag = 3;
                            }
                        }
                        else if (context.Request["do"] == "login")
                        {
                            if (context.Session["error"] == null)
                                context.Session["error"] = 5;
                            try
                            {
                                if (new CAS.User(context.Request.Form["username"]).Login(context.Request.Form["password"]))
                                {
                                    context.Session["error"] = 5;
                                    r_flag = 0;
                                }
                                else
                                {
                                    context.Session["error"] = int.Parse(context.Session["error"].ToString()) - 1;
                                    r_flag = 2;
                                }
                            }
                            catch
                            {
                                context.Session["error"] = int.Parse(context.Session["error"].ToString()) - 5;
                            }
                        }
                        else if (context.Request["do"] == "logout" && CAS.User.IsLogin)
                        {
                            CAS.User.Current.Logout();
                            r_flag = 0;
                        }
                        else if (context.Request["do"] == "list" && CAS.User.IsLogin)
                        {
                            try
                            {
                                r_flag = 0;
                                r_data = new CAS.SqlIntegrate(CAS.Utility.connStr).AdapterJSON("SELECT UUID, username, name, intro FROM CAS_User ORDER BY [name] collate Chinese_PRC_CS_AS_KS_WS");
                            }
                            catch (Exception ex)
                            {
                                CAS.Utility.Log(ex);
                                r_flag = 3;
                            }
                        }
                        else if (context.Request["do"] == "info" && CAS.User.IsLogin)
                        {
                            if (context.Request["UUID"] != null)
                                try
                                {
                                    CAS.SqlIntegrate si = new CAS.SqlIntegrate(CAS.Utility.connStr);
                                    r_data = si.QueryJSON("SELECT username, name, mail, QQ, phone, birthday FROM CAS_User WHERE [UUID]='" + Guid.Parse(context.Request["UUID"]).ToString().ToUpper() + "'");
                                    r_flag = 0;
                                }
                                catch (Exception ex)
                                {
                                    CAS.Utility.Log(ex);
                                    r_flag = 3;
                                }
                            else if (context.Request.Form.Count == 0)
                                try
                                {
                                    CAS.SqlIntegrate si = new CAS.SqlIntegrate(CAS.Utility.connStr);
                                    r_data = si.QueryJSON("SELECT mail, QQ, phone, birthday, intro FROM CAS_User WHERE [UUID]='" + CAS.User.Current.UUID + "'");
                                    r_flag = 0;
                                }
                                catch (Exception ex)
                                {
                                    CAS.Utility.Log(ex);
                                    r_flag = 3;
                                }
                            else if (context.Request.Form.Count == 5)
                                try
                                {
                                    CAS.SqlIntegrate si = new CAS.SqlIntegrate(CAS.Utility.connStr);
                                    si.InitParameter(5);
                                    si.AddParameter("@QQ", CAS.SqlIntegrate.DataType.NVarChar, context.Request.Form["qq"], 50);
                                    si.AddParameter("@mail", CAS.SqlIntegrate.DataType.NVarChar, context.Request.Form["mail"], 50);
                                    si.AddParameter("@phone", CAS.SqlIntegrate.DataType.NVarChar, context.Request.Form["phone"], 50);
                                    si.AddParameter("@birthday", CAS.SqlIntegrate.DataType.Date, context.Request.Form["birthday"]);
                                    si.AddParameter("@intro", CAS.SqlIntegrate.DataType.NVarChar, context.Request.Form["intro"], 255);
                                    si.Execute("UPDATE CAS_User SET [QQ] = @QQ, [mail] = @mail, [phone] = @phone, [birthday] = @birthday, [intro] = @intro WHERE [UUID] = '" + CAS.User.Current.UUID + "'");
                                    r_flag = 0;
                                }
                                catch (Exception ex)
                                {
                                    CAS.Utility.Log(ex);
                                    r_flag = 3;
                                }
                            else if (context.Request.Form.Count == 2)
                                try
                                {
                                    if (CAS.User.Current.SetPassword(context.Request.Form["password"], context.Request.Form["passwordn"]))
                                        r_flag = 0;
                                    else
                                        r_flag = 2;
                                }
                                catch (Exception ex)
                                {
                                    CAS.Utility.Log(ex);
                                    r_flag = 3;
                                }
                        }
                        else if (context.Request["do"] == "avatar" && CAS.User.IsLogin)
                        {
                            try
                            {
                                HttpPostedFile hpf = context.Request.Files[0];
                                string name = CAS.User.Current.UUID + "_" + DateTime.Now.ToString("HHmmssfff") + ".jpg";
                                hpf.SaveAs(context.Server.MapPath("Photo") + "\\" + name);
                                Stream fs = new FileStream(context.Server.MapPath("Photo") + "\\" + name, FileMode.Open);
                                CAS.Utility.MakeSmallImg(fs, context.Server.MapPath("Photo") + "\\c_" + name, 700, 700);
                                fs.Close();
                                FileInfo file = new FileInfo(context.Server.MapPath("Photo") + "\\" + name);
                                file.Delete();
                                context.Session["avatarpath"] = name;
                                r_data = "{\"ipath\":\"" + name + "\"}";
                                r_flag = 0;
                            }
                            catch (Exception ex)
                            {
                                CAS.Utility.Log(ex);
                                r_flag = 3;
                            }
                        }
                        else if (context.Request["do"] == "crop" && CAS.User.IsLogin)
                        {
                            try
                            {
                                string original = context.Server.MapPath("Photo") + "\\c_" + context.Session["avatarpath"];
                                string storage = context.Server.MapPath("Photo") + "\\" + CAS.User.Current.UUID + ".jpg";
                                int x = int.Parse(context.Request.Form["x"]), y = int.Parse(context.Request.Form["y"]), w = int.Parse(context.Request.Form["w"]), h = int.Parse(context.Request.Form["h"]);
                                Bitmap OriginalImage = new Bitmap(original);
                                Bitmap bmp = new Bitmap(w, h, OriginalImage.PixelFormat);
                                bmp.SetResolution(OriginalImage.HorizontalResolution, OriginalImage.VerticalResolution);
                                Graphics Graphic = Graphics.FromImage(bmp);
                                Graphic.SmoothingMode = SmoothingMode.AntiAlias;
                                Graphic.InterpolationMode = InterpolationMode.HighQualityBicubic;
                                Graphic.PixelOffsetMode = PixelOffsetMode.HighQuality;
                                Graphic.DrawImage(OriginalImage, new Rectangle(0, 0, w, h), x, y, w, h, GraphicsUnit.Pixel);
                                var ms = new MemoryStream();
                                bmp.Save(ms, OriginalImage.RawFormat);
                                if (File.Exists(storage))
                                    File.Delete(storage);
                                CAS.Utility.MakeSmallImg(ms, storage, 80, 80);
                                ms.Close();
                                r_flag = 0;
                            }
                            catch (Exception ex)
                            {
                                CAS.Utility.Log(ex);
                                r_flag = 3;
                            }
                        }
                    }
                    break;
                case "talk":
                    {
                        if (context.Request["do"] == "get" && CAS.User.IsLogin && CAS.User.Current.Permission(CAS.User.PermissionType.TALKSUBT) != 0)
                        {
                            try
                            {
                                r_data = new CAS.SqlIntegrate(CAS.Utility.connStr).AdapterJSON("SELECT GUID, CAS_talk.UUID, name, username, date, [content] FROM CAS_talk, CAS_User WHERE [GUID] NOT IN (SELECT [TUID] FROM CAS_Talklog WHERE [UUID] = '" + CAS.User.Current.UUID + "') AND CAS_User.[UUID] = CAS_Talk.[UUID]");
                                r_flag = 0;
                            }
                            catch (Exception ex)
                            {
                                CAS.Utility.Log(ex);
                                r_flag = 3;
                            }
                        }
                        else if (context.Request["do"] == "read" && CAS.User.IsLogin)
                        {
                            if (Convert.ToInt32(new CAS.SqlIntegrate(CAS.Utility.connStr).Query("SELECT COUNT(*) FROM CAS_Talklog WHERE TUID='" + Guid.Parse(context.Request["TUID"]).ToString().ToUpper() + "' AND UUID='" + CAS.User.Current.UUID + "'")) == 0)
                                new CAS.SqlIntegrate(CAS.Utility.connStr).Execute("INSERT INTO CAS_Talklog (TUID, UUID, type) VALUES ('" + Guid.Parse(context.Request["TUID"]).ToString().ToUpper() + "', '" + CAS.User.Current.UUID + "', 0)");
                            r_flag = 0;
                        }
                        else if (context.Request["do"] == "praise" && CAS.User.IsLogin)
                        {
                            if (Convert.ToInt32(new CAS.SqlIntegrate(CAS.Utility.connStr).Query("SELECT COUNT(*) FROM CAS_Talklog WHERE TUID='" + Guid.Parse(context.Request["TUID"]).ToString().ToUpper() + "' AND UUID='" + CAS.User.Current.UUID + "'")) == 0)
                                new CAS.SqlIntegrate(CAS.Utility.connStr).Execute("INSERT INTO CAS_Talklog (TUID, UUID, type) VALUES ('" + Guid.Parse(context.Request["TUID"]).ToString().ToUpper() + "', '" + CAS.User.Current.UUID + "', 1)");
                            r_flag = 0;
                        }
                        else if (context.Request["do"] == "submit" && CAS.User.IsLogin)
                        {
                            try
                            {
                                CAS.SqlIntegrate si = new CAS.SqlIntegrate(CAS.Utility.connStr);
                                si.InitParameter(1);
                                si.AddParameter("@content", CAS.SqlIntegrate.DataType.NVarChar, context.Request.Form["content"], 255);
                                si.Execute("INSERT INTO CAS_Talk ([content], [UUID]) VALUES (@content, '" + CAS.User.Current.UUID + "')");
                                r_flag = 0;
                            }
                            catch (Exception ex)
                            {
                                r_flag = 3;
                                CAS.Utility.Log(ex);
                            }
                        }
                        else if (context.Request["do"] == "list" && CAS.User.IsLogin)
                        {
                            try
                            {
                                r_flag = 0;
                                r_data = new CAS.SqlIntegrate(CAS.Utility.connStr).AdapterJSON("SELECT CAS_Talk.[content], CAS_Talk.[date], CAS_User.[name], CAS_User.[username], CAS_User.[UUID] FROM CAS_talk, CAS_User WHERE CAS_User.[UUID] = CAS_Talk.[UUID] ORDER BY CAS_Talk.[date] DESC");
                            }
                            catch (Exception ex)
                            {
                                CAS.Utility.Log(ex);
                                r_flag = 3;
                            }
                        }
                    }
                    break;
                case "bulletin":
                    {
                        if (context.Request["do"] == "submit" && CAS.User.IsLogin && CAS.User.Current.Permission(CAS.User.PermissionType.BULLETIN) != 0)
                        {
                            try
                            {
                                CAS.SqlIntegrate si = new CAS.SqlIntegrate(CAS.Utility.connStr);
                                si.InitParameter(2);
                                si.AddParameter("@title", CAS.SqlIntegrate.DataType.NVarChar, context.Request.Form["title"], 50);
                                si.AddParameter("@content", CAS.SqlIntegrate.DataType.Text, Encoding.UTF8.GetString(Convert.FromBase64String(context.Request.Form["content"])));
                                string GUID = new CAS.SqlIntegrate(CAS.Utility.connStr).Query("SELECT [GUID] FROM CAS_Notice WHERE ID = " +
                                    si.Query("INSERT INTO CAS_Notice ([title], [content], [UUID]) VALUES (@title, @content, '" + CAS.User.Current.UUID + "') SELECT @@IDENTITY AS returnName;")
                                ).ToString();
                                r_data = "{\"GUID\":\"" + GUID + "\"}";
                                r_flag = 0;
                            }
                            catch (Exception ex)
                            {
                                CAS.Utility.Log(ex);
                                r_flag = 3;
                            }
                        }
                        else if (context.Request["do"] == "info" && CAS.User.IsLogin)
                        {
                            try {
                                CAS.SqlIntegrate si = new CAS.SqlIntegrate(CAS.Utility.connStr);
                                DataRow dr = si.Reader("SELECT * FROM CAS_Notice WHERE [GUID] = '" + Guid.Parse(context.Request["GUID"]).ToString().ToUpper() + "'");
                                r_flag = 0;
                                r_data = "{\"title\":\"" + dr["title"].ToString() + "\",\"content\":\"" + Convert.ToBase64String(Encoding.UTF8.GetBytes(dr["content"].ToString())) + "\",\"date\":\"" +  dr["date"].ToString() + "\"}";
                            }
                            catch (Exception ex)
                            {
                                CAS.Utility.Log(ex);
                                r_flag = 3;
                            }

                        }
                        else if (context.Request["do"] == "search" && CAS.User.IsLogin)
                        {
                            try
                            {
                                CAS.SqlIntegrate si = new CAS.SqlIntegrate(CAS.Utility.connStr);
                                si.InitParameter(1);
                                si.AddParameter("@key", CAS.SqlIntegrate.DataType.VarChar, context.Request.Form["key"], 50);
                                r_data =si.AdapterJSON("SELECT title, GUID FROM CAS_Notice WHERE CONTAINS(title, @key) OR CONTAINS([content], @key)");
                                r_flag = 0;
                            }
                            catch (Exception ex)
                            {
                                CAS.Utility.Log(ex);
                                r_flag = 3;
                            }
                        }
                    }
                    break;
                case "calendar":
                    {
                        if (context.Request["do"] == "submit" && CAS.User.IsLogin && CAS.User.Current.Permission(CAS.User.PermissionType.CALENDAR) != 0)
                        {
                            try
                            {
                                CAS.SqlIntegrate si = new CAS.SqlIntegrate(CAS.Utility.connStr);
                                si.InitParameter(3);
                                si.AddParameter("@info", CAS.SqlIntegrate.DataType.NVarChar, context.Request.Form["info"], 50);
                                si.AddParameter("@start", CAS.SqlIntegrate.DataType.Date, context.Request.Form["start"]);
                                si.AddParameter("@end", CAS.SqlIntegrate.DataType.Date, context.Request.Form["end"]);
                                si.Execute("INSERT INTO CAS_Calendar ([info], [start], [end], [UUID]) VALUES (@info, @start, @end, '" + CAS.User.Current.UUID + "')");
                                r_flag = 0;
                            }
                            catch (Exception ex)
                            {
                                CAS.Utility.Log(ex);
                                r_flag = 3;
                            }
                        }
                        else if (context.Request["do"] == "get" && CAS.User.IsLogin)
                        {
                            try
                            {
                                CAS.SqlIntegrate si = new CAS.SqlIntegrate(CAS.Utility.connStr);
                                DataTable dt = si.Adapter("SELECT * FROM CAS_Calendar");
                                for (int i = 0; i < dt.Rows.Count; i++)
                                    r_data += "{\"title\": \"" + dt.Rows[i]["info"].ToString().Replace("\"", "") + "\", \"startstr\": \"" + dt.Rows[i]["start"].ToString().Replace(" 0:00:00","") + "\", \"endstr\": \"" + dt.Rows[i]["end"].ToString().Replace(" 0:00:00","") + "\"},";
                                dt = si.Adapter("SELECT * FROM CAS_User");
                                for (int i = 0; i < dt.Rows.Count; i++)
                                {
                                    DateTime birthday;
                                    if (DateTime.TryParse(dt.Rows[i]["birthday"].ToString(), out birthday))
                                    {
                                        r_data += "{\"title\":\"" + dt.Rows[i]["name"].ToString() + "的生日\",\"startstr\": \"" + DateTime.Now.Year.ToString() + "-" + birthday.Month.ToString() + "-" + birthday.Day.ToString() + "\"},";
                                        r_data += "{\"title\":\"" + dt.Rows[i]["name"].ToString() + "的生日\",\"startstr\": \"" + (DateTime.Now.Year + 1).ToString() + "-" + birthday.Month.ToString() + "-" + birthday.Day.ToString() + "\"},";
                                    }
                                }
                                r_flag = 0;
                                r_data = ("[" + r_data + "]").Replace(",]", "]").Replace(",}", "}");
                            }
                            catch (Exception ex)
                            {
                                CAS.Utility.Log(ex);
                                r_flag = 3;
                            }
                        }
                    }
                    break;
                case "file":
                    {
                        if (context.Request["do"] == "list" && CAS.User.IsLogin)
                        {
                            try
                            {
                                string back = "";
                                DateTime dt = Convert.ToDateTime(context.Request["date"].ToString());
                                for (int sub = 0; sub < 9; sub++)
                                    //back = back + getFileList(sub, dt);
                                    ;
                                r_data = "{\"html\":\"" + Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(back)) + "\"}";
                                r_flag = 0;
                            }
                            catch (Exception ex)
                            {
                                CAS.Utility.Log(ex);
                                r_flag = 3;
                            }
                        }
                        else if (context.Request["do"] == "submit" && CAS.User.IsLogin && CAS.User.Current.Permission(CAS.User.PermissionType.FILEUPLD) != 0)
                        {

                        }
                        else if (context.Request["do"] == "get" && CAS.User.IsLogin)
                        {
                            try
                            {
                                string filename = new CAS.SqlIntegrate(CAS.Utility.connStr).Query("SELECT [name] FROM CAS_File WHERE [FUID] = '" + Guid.Parse(context.Request["FUID"]).ToString().ToUpper() + "'").ToString();
                                string path = context.Server.MapPath("Doc") + Guid.Parse(context.Request["FUID"]).ToString().ToUpper();
                                if (File.Exists(path) && filename != "")
                                {
                                    context.Response.ContentType = "application/octet-stream";
                                    if (context.Request.UserAgent.ToLower().IndexOf("trident") > -1)
                                    {
                                        char[] chars = filename.ToCharArray();
                                        StringBuilder builder = new StringBuilder();
                                        for (int index = 0; index < chars.Length; index++)
                                        {
                                            char chr = chars[index];
                                            bool needToEncode = (chr > 127 && !(char.IsLetterOrDigit(chr) || "$-_.+!*'(),@=&".IndexOf(chr) >= 0));
                                            if (needToEncode)
                                            {
                                                UTF8Encoding utf8 = new UTF8Encoding();
                                                byte[] encodedBytes = utf8.GetBytes(chars[index].ToString());
                                                for (int i = 0; i < encodedBytes.Length; i++)
                                                    builder.AppendFormat("%{0}", Convert.ToString(encodedBytes[i], 16));
                                                builder.Append(builder.ToString());
                                            }
                                            else
                                                builder.Append(chars[index]);
                                        }
                                        filename = builder.ToString();
                                    }
                                    if (context.Request.UserAgent.ToLower().IndexOf("firefox") > -1)
                                        context.Response.AddHeader("Content-Disposition", "attachment;filename=\"" + filename + "\"");
                                    else
                                        context.Response.AddHeader("Content-Disposition", "attachment;filename=" + filename);
                                    context.Response.WriteFile(path);
                                    context.Response.End();
                                }
                            }
                            catch (Exception ex)
                            {
                                CAS.Utility.Log(ex);
                                r_flag = 3;
                            }
                        }
                        else
                        {
                            context.Response.Write("Illegal access.");
                        }
                    }
                    break;
                case "gallery":
                    {
                        if (context.Request["do"] == "submit" && context.Request.Form["title"] != null && CAS.User.IsLogin && CAS.User.Current.Permission(CAS.User.PermissionType.PHOTOSUB) != 0)
                        {
                            try
                            {
                                CAS.SqlIntegrate si = new CAS.SqlIntegrate(CAS.Utility.connStr);
                                si.InitParameter(1);
                                si.AddParameter("@title", CAS.SqlIntegrate.DataType.NVarChar, context.Request.Form["title"]);
                                string GUID = new CAS.SqlIntegrate(CAS.Utility.connStr).Query("SELECT [GUID] FROM CAS_Photo WHERE ID = " +
                                    si.Query("INSERT INTO CAS_Photo ([title], [UUID]) VALUES (@title, '" + CAS.User.Current.UUID + "') SELECT @@IDENTITY AS returnName;")
                                ).ToString();
                                HttpPostedFile file = context.Request.Files[0];
                                file.SaveAs(context.Server.MapPath("Photo") + "\\" + GUID + ".jpg");
                                FileStream fs = File.OpenRead(context.Server.MapPath("Photo") + "\\" + GUID + ".jpg");
                                CAS.Utility.MakeSmallImg(fs, context.Server.MapPath("Photo") + "\\" + GUID + "_thumb.jpg", 300, 169);
                                fs.Close();
                                r_data = "{\"GUID\":\"" + GUID + "\"}";
                                r_flag = 0;
                            }
                            catch (Exception ex)
                            {
                                CAS.Utility.Log(ex);
                                r_flag = 3;
                            }
                        }
                    }
                    break;
                case "homework":
                    {
                        if (context.Request["do"] == "submit" && CAS.User.IsLogin && CAS.User.Current.Permission(CAS.User.PermissionType.HOMEWORK) != 0)
                        {
                            try
                            {
                                int subject = CAS.User.Current.Permission(CAS.User.PermissionType.HOMEWORK);//HAHA
                                string[] str = context.Request.Form["content"].Split(',');
                                for (int i = 1; i <= int.Parse(str[0]); i++)
                                    if (str[i] != "")
                                    {
                                        CAS.SqlIntegrate si = new CAS.SqlIntegrate(CAS.Utility.connStr);
                                        si.InitParameter(1);
                                        si.AddParameter("@info", CAS.SqlIntegrate.DataType.NVarChar, i + ". " + str[i], 255);
                                        si.Execute("INSERT INTO CAS_Homework ([subject], [info]) VALUES (" + subject + ", @info)");
                                    }
                                r_flag = 0;
                            }
                            catch (Exception ex)
                            {
                                CAS.Utility.Log(ex);
                                r_flag = 3;
                            }
                        }
                        else if (context.Request["do"] == "list" && CAS.User.IsLogin)
                        {
                            try
                            {
                                string back = "";
                                DateTime dt;
                                dt = Convert.ToDateTime(context.Request["date"]);
                                for (int sub = 0; sub < 9; sub++)
                                    //back = back + getHomework(sub, dt);
                                    r_data = "{\"html\":\"" + Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(back)) + "\"}";
                                r_flag = 0;
                            }
                            catch (Exception ex)
                            {
                                CAS.Utility.Log(ex);
                                r_flag = 3;
                            }
                        }
                    }
                    break;
                case "table":
                    {
                        if (context.Request["do"] == "submit" && CAS.User.IsLogin)
                        {
                            try {
                                CAS.SqlIntegrate si = new CAS.SqlIntegrate(CAS.Utility.connStr);
                                DataTable dt = si.Adapter("SELECT * FROM CAS_Table");

                                if (context.Request.Form.Count != 0)
                                {
                                    bool success = true;
                                    for (int i = 0; i < dt.Rows.Count; i++)
                                    {
                                        if (context.Request.Form["table - " + dt.Rows[i]["ID"].ToString()] == null)
                                        {
                                            System.Text.RegularExpressions.Regex reg = new System.Text.RegularExpressions.Regex(dt.Rows[i]["regexp"].ToString());
                                            System.Text.RegularExpressions.Match m = reg.Match(context.Request.Form["table-" + dt.Rows[i]["ID"].ToString()].ToString());
                                            if (m.Success || dt.Rows[i]["regexp"].ToString() == "^(.*)$")
                                            {
                                                si.InitParameter(1);
                                                si.AddParameter("@content", CAS.SqlIntegrate.DataType.NVarChar, context.Request.Form["table-" + dt.Rows[i]["ID"].ToString()].ToString(), 255);
                                                si.Execute("INSERT INTO CAS_TableContent (UUID, tableID, [value]) VALUES ('" + CAS.User.Current.UUID + "', " + dt.Rows[i]["ID"].ToString() + ", @content)");
                                            }
                                            else
                                                success = false;
                                        }
                                        else
                                            success = false;
                                    }
                                    if (success)
                                        r_flag = 0;
                                    else
                                        r_flag = 2;

                                }
                            }
                            catch (Exception ex)
                            {
                                CAS.Utility.Log(ex);
                                r_flag = 3;
                            }
                        }
                    }
                    break;
            }
        context.Response.Write("{\"flag\":\"" + r_flag_s[r_flag] + "\"" + ((r_data != "") ? (",\"data\":" + r_data) : "") + "}");
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}
