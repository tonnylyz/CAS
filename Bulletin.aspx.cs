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
    public string getBulletinList()
    {
        string back = "";
        SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM CAS_Notice WHERE [classnum] = '" + Session["classnum"].ToString() + "' ORDER BY [date] DESC", CAS.sqlConnStr);
        DataSet ds = new DataSet();
        da.Fill(ds);
        for (var i = 0; i < ds.Tables[0].Rows.Count && i < 20; i++)
        {
            back += "<li data-id='" + ds.Tables[0].Rows[i]["GUID"].ToString() + "'><a onclick=\"bulletinShowNotice(this);\">" + ds.Tables[0].Rows[i]["title"].ToString() + "</a></li>";
        }
        return back;
    }

    public string[] onpage = new string[3];
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request["ID"] != null)
        {
            SqlConnection conn = new SqlConnection(CAS.sqlConnStr);
            SqlCommand cmd = new SqlCommand("SELECT * FROM CAS_Notice WHERE [GUID] = @GUID", conn);
            SqlParameter para = new SqlParameter("@GUID", SqlDbType.VarChar, 50);
            para.Value = Request["ID"].ToString();
            cmd.Parameters.Add(para);
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
            catch (Exception ex)
            {
                CAS.log(ex);
            }
            finally
            {
                conn.Close();
            }
        }
        onpage[0] = getBulletinList();
    }
}