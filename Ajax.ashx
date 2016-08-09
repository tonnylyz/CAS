<%@ WebHandler Language="C#" Class="Ajax" %>
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.SessionState;
using CAS;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Serialization;

public class Ajax : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        Return r;
        r.Flag = 0;
        r.Data = "";
        try
        {
            if (context.Request["cat"] != null && context.Request["do"] != null)
                switch (context.Request["cat"])
                {
                    case "user":
                        {
                            if (context.Request["do"] == "register")
                            {
                                var si = new SqlIntegrate(Utility.connStr);
                                si.InitParameter(1);
                                si.AddParameter("@username", SqlIntegrate.DataType.VarChar, context.Request.Form["username"], 8);
                                if (Convert.ToInt32(si.Query("SELECT COUNT(*) FROM CAS_User WHERE username = @username")) == 0)
                                {
                                    si.InitParameter(9);
                                    si.AddParameter("@username", SqlIntegrate.DataType.VarChar,
                                        context.Request.Form["username"], 50);
                                    si.AddParameter("@realname", SqlIntegrate.DataType.NVarChar,
                                        context.Request.Form["realname"], 10);
                                    si.AddParameter("@SN", SqlIntegrate.DataType.VarChar, context.Request.Form["SN"], 8);
                                    si.AddParameter("@password", SqlIntegrate.DataType.VarChar,
                                        Utility.Encrypt(context.Request.Form["password"]), 50);
                                    si.AddParameter("@birthday", SqlIntegrate.DataType.Date,
                                        context.Request.Form["birthday"]);
                                    si.AddParameter("@QQ", SqlIntegrate.DataType.VarChar, context.Request.Form["QQ"], 20);
                                    si.AddParameter("@mail", SqlIntegrate.DataType.VarChar, context.Request.Form["mail"], 50);
                                    si.AddParameter("@phone", SqlIntegrate.DataType.VarChar, context.Request.Form["phone"],
                                        50);
                                    si.AddParameter("@intro", SqlIntegrate.DataType.NVarChar, context.Request.Form["intro"],
                                        255);
                                    si.Execute(
                                        "UPDATE CAS_User SET username = @username, pwd = @password, birthday = @birthday, QQ = @QQ, mail = @mail, phone = @phone, intro = @intro  WHERE name = @realname AND SN = @SN AND pwd IS NULL");
                                    new User(context.Request.Form["username"]).Login(context.Request.Form["password"]);
                                    context.Session["firsttime"] = true;
                                }
                                else
                                    r.Flag = 2;
                            }
                            else if (context.Request["do"] == "login")
                            {
                                if (!new User(context.Request.Form["username"]).Login(context.Request.Form["password"]))
                                    r.Flag = 2;
                            }
                            else if (context.Request["do"] == "logout" && User.IsLogin)
                            {
                                User.Current.Logout();
                            }
                            else if (context.Request["do"] == "list" && User.IsLogin)
                            {
                                r.Data =
                                    new SqlIntegrate(Utility.connStr).AdapterJson(
                                        "SELECT UUID, username, name, intro FROM CAS_User ORDER BY [name] collate Chinese_PRC_CS_AS_KS_WS");
                            }
                            else if (context.Request["do"] == "info" && User.IsLogin)
                            {
                                if (context.Request["UUID"] != null)
                                    r.Data =
                                        (new SqlIntegrate(Utility.connStr)).QueryJson(
                                            string.Format("SELECT username, name, mail, QQ, phone, birthday FROM CAS_User WHERE [UUID]='{0}'", Guid.Parse(context.Request["UUID"]).ToString().ToUpper()));
                                else if (context.Request.Form.Count == 0)
                                    r.Data =
                                        (new SqlIntegrate(Utility.connStr)).QueryJson(
                                            string.Format("SELECT mail, QQ, phone, birthday, intro FROM CAS_User WHERE [UUID]='{0}'", User.Current.UUID));
                                else if (context.Request.Form.Count == 5)
                                {
                                    var si = new SqlIntegrate(Utility.connStr);
                                    si.InitParameter(5);
                                    si.AddParameter("@QQ", SqlIntegrate.DataType.NVarChar, context.Request.Form["qq"], 50);
                                    si.AddParameter("@mail", SqlIntegrate.DataType.NVarChar, context.Request.Form["mail"], 50);
                                    si.AddParameter("@phone", SqlIntegrate.DataType.NVarChar, context.Request.Form["phone"], 50);
                                    si.AddParameter("@birthday", SqlIntegrate.DataType.Date, context.Request.Form["birthday"]);
                                    si.AddParameter("@intro", SqlIntegrate.DataType.NVarChar, context.Request.Form["intro"], 255);
                                    si.Execute(string.Format("UPDATE CAS_User SET [QQ] = @QQ, [mail] = @mail, [phone] = @phone, [birthday] = @birthday, [intro] = @intro WHERE [UUID] = '{0}'", User.Current.UUID));
                                }
                                else if (context.Request.Form.Count == 2)
                                    if (!User.Current.SetPassword(context.Request.Form["password"],
                                        context.Request.Form["passwordn"]))
                                        r.Flag = 2;
                            }
                            else if (context.Request["do"] == "avatar" && User.IsLogin)
                            {
                                var name = User.Current.UUID + "_" + DateTime.Now.ToString("HHmmssfff") + ".jpg";
                                context.Request.Files[0].SaveAs(context.Server.MapPath("Photo") + "\\" + name);
                                Stream fs = new FileStream(context.Server.MapPath("Photo") + "\\" + name, FileMode.Open);
                                Utility.MakeSmallImg(fs, context.Server.MapPath("Photo") + "\\c_" + name, 700, 700);
                                fs.Close();
                                var file = new FileInfo(context.Server.MapPath("Photo") + "\\" + name);
                                file.Delete();
                                context.Session["avatarpath"] = name;
                                var o = new JObject();
                                o["ipath"] = name;
                                r.Data = o;
                            }
                            else if (context.Request["do"] == "crop" && User.IsLogin)
                            {
                                var original = context.Server.MapPath("Photo") + "\\c_" + context.Session["avatarpath"];
                                var storage = context.Server.MapPath("Photo") + "\\" + User.Current.UUID + ".jpg";
                                int x = int.Parse(context.Request.Form["x"]),
                                    y = int.Parse(context.Request.Form["y"]),
                                    w = int.Parse(context.Request.Form["w"]),
                                    h = int.Parse(context.Request.Form["h"]);
                                var originalImage = new Bitmap(original);
                                var bmp = new Bitmap(w, h, originalImage.PixelFormat);
                                bmp.SetResolution(originalImage.HorizontalResolution, originalImage.VerticalResolution);
                                var graphic = Graphics.FromImage(bmp);
                                graphic.SmoothingMode = SmoothingMode.AntiAlias;
                                graphic.InterpolationMode = InterpolationMode.HighQualityBicubic;
                                graphic.PixelOffsetMode = PixelOffsetMode.HighQuality;
                                graphic.DrawImage(originalImage, new Rectangle(0, 0, w, h), x, y, w, h, GraphicsUnit.Pixel);
                                var ms = new MemoryStream();
                                bmp.Save(ms, originalImage.RawFormat);
                                if (File.Exists(storage))
                                    File.Delete(storage);
                                Utility.MakeSmallImg(ms, storage, 80, 80);
                                ms.Close();
                            }
                        }
                        break;
                    case "talk":
                        {
                            if (context.Request["do"] == "get" && User.IsLogin &&
                                User.Current.Permission(User.PermissionType.TALKSUBT) != 0)
                            {
                                r.Data =
                                    new SqlIntegrate(Utility.connStr).AdapterJson(
                                        string.Format("SELECT GUID, CAS_talk.UUID, name, username, date, [content] FROM CAS_talk, CAS_User WHERE [GUID] NOT IN (SELECT [TUID] FROM CAS_Talklog WHERE [UUID] = '{0}') AND CAS_User.[UUID] = CAS_Talk.[UUID]", User.Current.UUID));
                            }
                            else if (context.Request["do"] == "read" && User.IsLogin)
                            {
                                if (
                                    Convert.ToInt32(
                                        new SqlIntegrate(Utility.connStr).Query(
                                            string.Format("SELECT COUNT(*) FROM CAS_Talklog WHERE TUID='{0}' AND UUID='{1}'", Guid.Parse(context.Request["TUID"]).ToString().ToUpper(), User.Current.UUID))) == 0)
                                    new SqlIntegrate(Utility.connStr).Execute(
                                        string.Format("INSERT INTO CAS_Talklog (TUID, UUID, type) VALUES ('{0}', '{1}', 0)", Guid.Parse(context.Request["TUID"]).ToString().ToUpper(), User.Current.UUID));
                            }
                            else if (context.Request["do"] == "praise" && User.IsLogin)
                            {
                                if (
                                    Convert.ToInt32(
                                        new SqlIntegrate(Utility.connStr).Query(
                                            string.Format("SELECT COUNT(*) FROM CAS_Talklog WHERE TUID='{0}' AND UUID='{1}'", Guid.Parse(context.Request["TUID"]).ToString().ToUpper(), User.Current.UUID))) == 0)
                                    new SqlIntegrate(Utility.connStr).Execute(
                                        string.Format("INSERT INTO CAS_Talklog (TUID, UUID, type) VALUES ('{0}', '{1}', 1)", Guid.Parse(context.Request["TUID"]).ToString().ToUpper(), User.Current.UUID));
                            }
                            else if (context.Request["do"] == "submit" && User.IsLogin)
                            {
                                var si = new SqlIntegrate(Utility.connStr);
                                si.InitParameter(1);
                                si.AddParameter("@content", SqlIntegrate.DataType.NVarChar, context.Request.Form["content"], 255);
                                si.Execute(string.Format("INSERT INTO CAS_Talk ([content], [UUID]) VALUES (@content, '{0}')", User.Current.UUID));

                            }
                            else if (context.Request["do"] == "list" && User.IsLogin)
                            {
                                r.Data =
                                    new SqlIntegrate(Utility.connStr).AdapterJson(
                                        "SELECT CAS_Talk.[content], CAS_Talk.[date], CAS_User.[name], CAS_User.[username], CAS_User.[UUID] FROM CAS_talk, CAS_User WHERE CAS_User.[UUID] = CAS_Talk.[UUID] ORDER BY CAS_Talk.[date] DESC");
                            }
                        }
                        break;
                    case "bulletin":
                        {
                            if (context.Request["do"] == "submit" && User.IsLogin &&
                                User.Current.Permission(User.PermissionType.BULLETIN) != 0)
                            {
                                var si = new SqlIntegrate(Utility.connStr);
                                si.InitParameter(2);
                                si.AddParameter("@title", SqlIntegrate.DataType.NVarChar, context.Request.Form["title"], 50);
                                si.AddParameter("@content", SqlIntegrate.DataType.Text,
                                    Encoding.UTF8.GetString(Convert.FromBase64String(context.Request.Form["content"])));
                                var guid =
                                    new SqlIntegrate(Utility.connStr).Query("SELECT [GUID] FROM CAS_Notice WHERE ID = " +
                                                                            si.Query(
                                                                                string.Format("INSERT INTO CAS_Notice ([title], [content], [UUID]) VALUES (@title, @content, '{0}') SELECT @@IDENTITY AS returnName;", User.Current.UUID))
                                        ).ToString();
                                var o = new JObject();
                                o["GUID"] = guid;
                                r.Data = o;
                                r.Flag = 0;
                            }
                            else if (context.Request["do"] == "info" && User.IsLogin)
                            {
                                var dr =
                                    (new SqlIntegrate(Utility.connStr)).Reader(string.Format("SELECT * FROM CAS_Notice WHERE [GUID] = '{0}'", Guid.Parse(context.Request["GUID"]).ToString().ToUpper()));
                                var o = new JObject();
                                o["title"] = dr["title"].ToString();
                                o["content"] = Convert.ToBase64String(Encoding.UTF8.GetBytes(dr["content"].ToString()));
                                o["date"] = dr["date"].ToString();
                                r.Data = o;

                            }
                            else if (context.Request["do"] == "search" && User.IsLogin)
                            {
                                var si = new SqlIntegrate(Utility.connStr);
                                si.InitParameter(1);
                                si.AddParameter("@key", SqlIntegrate.DataType.VarChar, context.Request.Form["key"], 50);
                                r.Data =
                                    si.AdapterJson(
                                        "SELECT title, GUID FROM CAS_Notice WHERE CONTAINS(title, @key) OR CONTAINS([content], @key)");
                            }
                        }
                        break;
                    case "calendar":
                        {
                            if (context.Request["do"] == "submit" && User.IsLogin &&
                                User.Current.Permission(User.PermissionType.CALENDAR) != 0)
                            {
                                var si = new SqlIntegrate(Utility.connStr);
                                si.InitParameter(3);
                                si.AddParameter("@info", SqlIntegrate.DataType.NVarChar, context.Request.Form["info"], 50);
                                si.AddParameter("@start", SqlIntegrate.DataType.Date, context.Request.Form["start"]);
                                si.AddParameter("@end", SqlIntegrate.DataType.Date, context.Request.Form["end"]);
                                si.Execute(
                                    string.Format("INSERT INTO CAS_Calendar ([info], [start], [end], [UUID]) VALUES (@info, @start, @end, '{0}')", User.Current.UUID));

                            }
                            else if (context.Request["do"] == "get" && User.IsLogin)
                            {
                                var si = new SqlIntegrate(Utility.connStr);
                                var dt = si.Adapter("SELECT * FROM CAS_Calendar");
                                var a = new JArray();
                                for (var i = 0; i < dt.Rows.Count; i++)
                                {
                                    var o = new JObject();
                                    o["title"] = dt.Rows[i]["info"].ToString().Replace("\"", "");
                                    o["startstr"] = dt.Rows[i]["start"].ToString().Replace(" 0:00:00", "");
                                    o["endstr"] = dt.Rows[i]["end"].ToString().Replace(" 0:00:00", "");
                                    a.Add(o);
                                }
                                dt = si.Adapter("SELECT * FROM CAS_User");
                                for (var i = 0; i < dt.Rows.Count; i++)
                                {
                                    DateTime birthday;
                                    if (DateTime.TryParse(dt.Rows[i]["birthday"].ToString(), out birthday))
                                    {

                                        var o = new JObject();
                                        o["title"] = dt.Rows[i]["name"] + "的生日";
                                        o["startstr"] = DateTime.Now.Year + "-" + birthday.Month + "-" + birthday.Day;
                                        a.Add(o);
                                        o = new JObject();
                                        o["title"] = dt.Rows[i]["name"] + "的生日";
                                        o["startstr"] = (DateTime.Now.Year + 1) + "-" + birthday.Month + "-" + birthday.Day;
                                        a.Add(o);
                                    }
                                }
                                r.Data = a;
                            }
                        }
                        break;
                    case "gallery":
                        {
                            if (context.Request["do"] == "submit" && context.Request.Form["title"] != null && User.IsLogin &&
                                User.Current.Permission(User.PermissionType.PHOTOSUB) != 0)
                            {
                                var si = new SqlIntegrate(Utility.connStr);
                                si.InitParameter(1);
                                si.AddParameter("@title", SqlIntegrate.DataType.NVarChar, context.Request.Form["title"]);
                                var guid =
                                    new SqlIntegrate(Utility.connStr).Query(string.Format("SELECT [GUID] FROM CAS_Photo WHERE ID = {0}", si.Query(
                                            string.Format("INSERT INTO CAS_Photo ([title], [UUID]) VALUES (@title, '{0}') SELECT @@IDENTITY AS returnName;", User.Current.UUID)))
                                        ).ToString();
                                var file = context.Request.Files[0];
                                file.SaveAs(context.Server.MapPath("Photo") + "\\" + guid + ".jpg");
                                var fs = File.OpenRead(context.Server.MapPath("Photo") + "\\" + guid + ".jpg");
                                Utility.MakeSmallImg(fs, context.Server.MapPath("Photo") + "\\" + guid + "_thumb.jpg", 300, 169);
                                fs.Close();
                                JObject o = new JObject();
                                o["GUID"] = guid;
                                r.Data = o;
                            }
                        }
                        break;
                    case "table":
                        {
                            if (context.Request["do"] == "submit" && User.IsLogin)
                            {
                                var si = new SqlIntegrate(Utility.connStr);
                                var dt = si.Adapter("SELECT * FROM CAS_Table");

                                if (context.Request.Form.Count != 0)
                                {
                                    var success = true;
                                    for (var i = 0; i < dt.Rows.Count; i++)
                                    {
                                        if (context.Request.Form["table - " + dt.Rows[i]["ID"]] == null)
                                        {
                                            var reg = new Regex(dt.Rows[i]["regexp"].ToString());
                                            var m = reg.Match(context.Request.Form["table-" + dt.Rows[i]["ID"]]);
                                            if (m.Success || dt.Rows[i]["regexp"].ToString() == "^(.*)$")
                                            {
                                                si.InitParameter(1);
                                                si.AddParameter("@content", SqlIntegrate.DataType.NVarChar,
                                                    context.Request.Form["table-" + dt.Rows[i]["ID"]], 255);
                                                si.Execute(
                                                    string.Format("INSERT INTO CAS_TableContent (UUID, tableID, [value]) VALUES ('{0}', {1}, @content)", User.Current.UUID, dt.Rows[i]["ID"]));
                                            }
                                            else
                                                success = false;
                                        }
                                        else
                                            success = false;
                                    }
                                    if (!success)
                                        r.Flag = 2;
                                }
                            }
                        }
                        break;
                }
        }
        catch (Exception ex)
        {
            Utility.Log(ex);
            throw;
        }

        context.Response.Write(JsonConvert.SerializeObject(
            value: r,
            formatting: Formatting.Indented,
            settings: new JsonSerializerSettings { ContractResolver = new CamelCasePropertyNamesContractResolver() })
        );
    }

    public bool IsReusable
    {
        get { return false; }
    }

    private struct Return
    {
        public int Flag;
        public object Data;
    }
}
