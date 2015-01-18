using System;
using System.Data;
using System.Data.SqlClient;

public partial class Calendar : System.Web.UI.Page
{
    public string eventback = "";
    public string birthback = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        string cmd = "SELECT * FROM CAS_Calendar";
        SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sqlConnStr);
        DataSet ds = new DataSet();
        da.Fill(ds);
        for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            eventback = eventback + "{title: '" + ds.Tables[0].Rows[i]["info"].ToString() + "', start: new Date(" + Convert.ToDateTime(ds.Tables[0].Rows[i]["sdate"].ToString()).Year + ", " + (Convert.ToDateTime(ds.Tables[0].Rows[i]["sdate"].ToString()).Month - 1).ToString() + ", " + Convert.ToDateTime(ds.Tables[0].Rows[i]["sdate"].ToString()).Day + "),end: new Date(" + Convert.ToDateTime(ds.Tables[0].Rows[i]["edate"].ToString()).Year + ", " + (Convert.ToDateTime(ds.Tables[0].Rows[i]["edate"].ToString()).Month - 1).ToString() + ", " + Convert.ToDateTime(ds.Tables[0].Rows[i]["edate"].ToString()).Day + ")},";
        }
        string cmdb = "SELECT * FROM CAS_User";
        SqlDataAdapter dab = new SqlDataAdapter(cmdb, CAS.sqlConnStr);
        DataSet dsb = new DataSet();
        dab.Fill(dsb);
        for (var i = 0; i < dsb.Tables[0].Rows.Count; i++)
        {
            DateTime dt = DateTime.Now;
            if (DateTime.TryParse(dsb.Tables[0].Rows[i]["birthday"].ToString(), out dt))
            {
                birthback = birthback + "{title: '" + dsb.Tables[0].Rows[i]["name"].ToString() + "的生日',start: new Date(" + DateTime.Now.Year + " , " + (Convert.ToDateTime(dsb.Tables[0].Rows[i]["birthday"].ToString()).Month - 1).ToString() + ", " + Convert.ToDateTime(dsb.Tables[0].Rows[i]["birthday"].ToString()).Day + ")},";
                birthback = birthback + "{title: '" + dsb.Tables[0].Rows[i]["name"].ToString() + "的生日',start: new Date(" + (DateTime.Now.Year + 1) + " , " + (Convert.ToDateTime(dsb.Tables[0].Rows[i]["birthday"].ToString()).Month - 1).ToString() + ", " + Convert.ToDateTime(dsb.Tables[0].Rows[i]["birthday"].ToString()).Day + ")},";
            }
        }
        birthback = birthback.Remove(birthback.Length - 1);
    }
}