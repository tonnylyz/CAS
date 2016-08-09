using System;
using System.Text;
using System.Security.Cryptography;
using System.Web;

namespace CAS
{
    /// <summary>
    /// CAS 网站配置以及公用函数
    /// </summary>
    public class Utility
    {
        public static string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString();
        public static void Log(string message)
        {
            SqlIntegrate si = new SqlIntegrate(connStr);
            si.InitParameter(5);
            si.AddParameter("@context", SqlIntegrate.DataType.Text, message);
            si.AddParameter("@IP", SqlIntegrate.DataType.VarChar, HttpContext.Current.Request.UserHostAddress, 50);
            si.AddParameter("@browser", SqlIntegrate.DataType.Text, HttpContext.Current.Request.UserAgent);
            si.AddParameter("@OS", SqlIntegrate.DataType.VarChar, HttpContext.Current.Request.Browser.Platform, 50);
            si.AddParameter("@session", SqlIntegrate.DataType.VarChar, User.IsLogin ? User.Current.username : "未登录用户", 50);
            si.Execute("INSERT INTO Log ([context], [IP], [browser], [OS], [session]) VALUES (@context, @IP, @browser, @OS, @session)");
        }
        public static void Log(Exception message)
        {
            Log(message.Message + message.StackTrace);
        }
        public static string Encrypt(string password)
        {
            MD5 md5 = new MD5CryptoServiceProvider();
            byte[] data = Encoding.Default.GetBytes(password);
            byte[] md5data = md5.ComputeHash(data);
            md5.Clear();
            string str = "";
            for (int i = 0; i < md5data.Length - 1; i++)
                str += md5data[i].ToString("X").PadLeft(2, '0');
            return str;
        }
        public static string String2JSON(string str)
        {
            str = str.Replace(">", "&gt;");
            str = str.Replace("<", "&lt;");
            str = str.Replace(" ", "&nbsp;");
            str = str.Replace("\"", "&quot;");
            str = str.Replace("\'", "&#39;");
            str = str.Replace("\\", "\\\\");
            str = str.Replace("\n", "\\n");
            str = str.Replace("\r", "\\r");
            return str;
        }
        public static void MakeSmallImg(System.IO.Stream fromFileStream, string fileSaveUrl, double templateWidth, double templateHeight)
        {
            try
            {
                System.Drawing.Image myImage = System.Drawing.Image.FromStream(fromFileStream, true);
                double newWidth = myImage.Width, newHeight = myImage.Height;
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
                System.Drawing.Size mySize = new System.Drawing.Size((int)newWidth, (int)newHeight);
                System.Drawing.Image bitmap = new System.Drawing.Bitmap(mySize.Width, mySize.Height);
                System.Drawing.Graphics g = System.Drawing.Graphics.FromImage(bitmap);
                g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
                g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
                g.Clear(System.Drawing.Color.White);
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
                Log(ex);
            }
        }
    }
}