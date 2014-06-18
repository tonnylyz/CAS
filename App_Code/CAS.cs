﻿using System;
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

    public static string sql_connstr = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString();

    public static string sql_execute(string command)
    {
        object back = null;
        SqlConnection conn = new SqlConnection(sql_connstr);
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