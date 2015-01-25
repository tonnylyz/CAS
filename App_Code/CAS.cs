using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;

public class CAS
{
    
	public CAS()
	{

	}
    public static string[] subject = new string[9] {"语文", "数学", "英语", "物理", "化学", "生物", "政治", "历史", "地理" };

    public static string sqlConnStr = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString();

    public static string sqlExecute(string command)
    {
        object back = null;
        SqlConnection conn = new SqlConnection(sqlConnStr);
        SqlCommand cmd = new SqlCommand(command, conn);
        try
        {
            conn.Open();
            back = cmd.ExecuteScalar();
        }
        catch(Exception ex)
        {
            log(ex);
        }
        finally
        {
            conn.Close();
        }
        if (!Convert.IsDBNull(back) && back != null)
            return back.ToString();
        else
            return "";
    }
    public static string dateToString(DateTime dt)
    {
        string date = dt.Year + "-" + dt.Month + "-" + dt.Day;
        return date;
    }
    public static string sqlAdapter(string cmd, string[] key)
    {
        //Return a JSON in string
        string back = "[";
        SqlDataAdapter da = new SqlDataAdapter(cmd, sqlConnStr);
        DataSet ds = new DataSet();
        da.Fill(ds);
        for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            back += "{";
            foreach (string col in key)
                back += "\"" + col + "\": \"" + ds.Tables[0].Rows[i][col].ToString() + "\",";
            back += "},";
        }
        back += "]";
        return back.Replace(",}", "}").Replace(",]", "]");
    }

    public static string sqlAdapter(string cmd, string[] key, SqlParameter[] para)
    {
        //Return a JSON in string
        string back = "[";
        SqlDataAdapter da = new SqlDataAdapter(cmd, sqlConnStr);
        for (int i = 0; i < para.Count(); i++) 
            da.SelectCommand.Parameters.Add(para[i]);
        DataSet ds = new DataSet();
        da.Fill(ds);
        for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            back += "{";
            foreach (string col in key)
                back += "\"" + col + "\": \"" + ds.Tables[0].Rows[i][col].ToString() + "\",";
            back += "},";
        }
        back += "]";
        return back.Replace(",}", "}").Replace(",]", "]");
    }

    public static string encrypt(string strPwd)
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

    

    public static void makeSmallImg(System.IO.Stream fromFileStream, string fileSaveUrl, System.Double templateWidth, System.Double templateHeight)
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
            CAS.log(ex);
        }
    }

    public static void log(Exception ex)
    {

    }
    public static void log(string str)
    {

    }
}