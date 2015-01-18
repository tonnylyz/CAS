using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Text;

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
            return ex.Message;
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

    public static string ToHexString(string s)
    {
        char[] chars = s.ToCharArray();
        StringBuilder builder = new StringBuilder();
        for (int index = 0; index < chars.Length; index++)
        {
            bool needToEncode = NeedToEncode(chars[index]);
            if (needToEncode)
            {
                string encodedString = ToHexString(chars[index]);
                builder.Append(encodedString);
            }
            else
            {
                builder.Append(chars[index]);
            }
        }

        return builder.ToString();
    }

    private static bool NeedToEncode(char chr)
    {
        string reservedChars = "$-_.+!*'(),@=&";

        if (chr > 127)
            return true;
        if (char.IsLetterOrDigit(chr) || reservedChars.IndexOf(chr) >= 0)
            return false;

        return true;
    }
    public static void log(Exception ex)
    {

    }
    public static void log(string str)
    {

    }
    private static string ToHexString(char chr)
    {
        UTF8Encoding utf8 = new UTF8Encoding();
        byte[] encodedBytes = utf8.GetBytes(chr.ToString());
        StringBuilder builder = new StringBuilder();
        for (int index = 0; index < encodedBytes.Length; index++)
        {
            builder.AppendFormat("%{0}", Convert.ToString(encodedBytes[index], 16));
        }
        return builder.ToString();
    }
}