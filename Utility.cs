using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Newtonsoft.Json.Linq;

namespace cas
{
    public class Utility
    {
        public IList<SqlParameter> QueryParameters = new List<SqlParameter>();
        
        public JArray AdapterJson(string command)
        {
            using (var da = new SqlDataAdapter(command, Startup.ConnStr))
            {
                    foreach (var para in QueryParameters)
                        da.SelectCommand.Parameters.Add(para);
                using (var ds = new DataSet())
                {
                    da.Fill(ds);
                    var a = new JArray();
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {
                        var o = new JObject();
                        foreach (DataColumn col in ds.Tables[0].Columns)
                            o.Add(col.ColumnName.Trim(), JToken.FromObject(dr[col]));
                        a.Add(o);
                    }
                    return a;
                }
            }
        }
        
        public DataTable Adapter(string command)
        {
            using (var da = new SqlDataAdapter(command, Startup.ConnStr))
            {
                foreach (var para in QueryParameters)
                    da.SelectCommand.Parameters.Add(para);
                using (var ds = new DataSet())
                {
                    da.Fill(ds);
                    return ds.Tables[0];
                }
            }
        }
        
        public Dictionary<string, object> Reader(string command)
        {
            using (var conn = new SqlConnection(Startup.ConnStr))
            {
                using (var cmd = new SqlCommand(command, conn))
                {
                    foreach (var para in QueryParameters)
                        cmd.Parameters.Add(para);
                    conn.Open();
                    using (var dr = cmd.ExecuteReader())
                    {
                        if (!dr.HasRows)
                            return null;
                        var cols = new List<string>();
                        for (var i = 0; i < dr.FieldCount; i++)
                            cols.Add(dr.GetName(i));
                        while (dr.Read())
                            return cols.ToDictionary(col => col, col => dr[col]);
                        return null;
                    }
                }
            }
        }
        
        public JObject QueryJson(string command)
        {
            using (var conn = new SqlConnection(Startup.ConnStr))
            {
                using (var cmd = new SqlCommand(command, conn))
                {
                    foreach (var para in QueryParameters)
                        cmd.Parameters.Add(para);
                    conn.Open();
                    using (var dr = cmd.ExecuteReader())
                    {
                        if (!dr.HasRows)
                            return null;
                        var cols = new List<string>();
                        for (var i = 0; i < dr.FieldCount; i++)
                            cols.Add(dr.GetName(i));
                        if (dr.Read())
                            return (JObject)JToken.FromObject(cols.ToDictionary(col => col, col => dr[col]));
                        return null;
                    }
                }
            }
        }
        
        public static string Encrypt(string strPwd)
        {
            System.Security.Cryptography.MD5 md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
            var data = md5.ComputeHash(System.Text.Encoding.Default.GetBytes(strPwd));
            md5.Clear();
            var str = "";
            for (var i = 0; i < data.Length - 1; i++)
                str += data[i].ToString("X").PadLeft(2, '0');
            return str;
        }
        
        public static string Base64Encode(string str)
        {
            return Convert.ToBase64String(Encoding.UTF8.GetBytes(str), Base64FormattingOptions.None);
        }
    }
}