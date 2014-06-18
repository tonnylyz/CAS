using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Bulletin : System.Web.UI.Page
{
    public string Getbulletinlist(DateTime dt1, DateTime dt2)
    {
        string back = "";
        SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM CAS_Notice WHERE date between '" + dt1.ToShortDateString() + "' and '" + dt2.ToShortDateString() + "'", CAS.sql_connstr);
        DataSet ds = new DataSet();
        da.Fill(ds);
        for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            back = "<li id='" + ds.Tables[0].Rows[i]["GUID"].ToString() + "'><a onclick=\"bulletin_shownotice('" + ds.Tables[0].Rows[i]["GUID"].ToString() + "');\">" + ds.Tables[0].Rows[i]["title"].ToString() + "</a></li>" + back;
        }
        return back;
    }
	
	public string[] onpage = new string[3] {"null","null","null"};
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["ID"]!=null)
        {
            int nid = 0;
            int.TryParse(Request["ID"].ToString(), out nid);
            SqlConnection conn = new SqlConnection(CAS.sql_connstr);
            SqlCommand cmd = new SqlCommand("SELECT * FROM CAS_Notice WHERE ID = @ID", conn);
            SqlParameter para1 = new SqlParameter("@ID", SqlDbType.Int);
            para1.Value = nid;
            cmd.Parameters.Add(para1);
            try
            {
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    onpage[1] = dr["title"].ToString();
                    onpage[2] = dr["info"].ToString();
                }
                dr.Close();
            }
            catch
            {

            }
            finally
            {
                conn.Close();
            }

        }
        onpage[0] = Getbulletinlist(DateTime.Now.AddDays(-365),DateTime.Now.AddDays(1));
    }
}