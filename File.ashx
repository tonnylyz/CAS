<%@ WebHandler Language="C#" Class="ajax" %>

using System;
using System.Web;
using System.Text;
using System.Data;
using System.Data.SqlClient;

public class ajax : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        if (context.Request["file"] != null)
        {
            string filename = "";
            SqlConnection conn = new SqlConnection(CAS.sqlConnStr);
            SqlCommand cmd = new SqlCommand("SELECT [filename] FROM CAS_File WHERE [GUID]=@GUID", conn);
            SqlParameter para = new SqlParameter("@GUID", SqlDbType.NVarChar, 50);
            para.Value = context.Request["file"].ToString();
            cmd.Parameters.Add(para);
            conn.Open();
            object back = cmd.ExecuteScalar();
            if (back != null && !Convert.IsDBNull(back))
                filename = back.ToString();
            conn.Close();
            string path = context.Server.MapPath("Doc/" + context.Request["file"].ToString());
            if (System.IO.File.Exists(path) && filename != "")
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
                            {
                                builder.AppendFormat("%{0}", Convert.ToString(encodedBytes[i], 16));
                            }
                            builder.Append(builder.ToString());
                        }
                        else
                        {
                            builder.Append(chars[index]);
                        }
                    }
                    filename = builder.ToString();
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
        else
        {
            context.Response.Write("illegal access.");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}