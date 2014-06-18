using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class Filelib : System.Web.UI.Page
{
	public string back = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        string cmd = "SELECT DISTINCT date FROM CAS_File ORDER BY date DESC";
        SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sql_connstr);
        DataSet ds = new DataSet();
        da.Fill(ds);
        for (var i = 0; i < 20; i++)
        {
            back = back + "<li><a onclick=\"filelib_loaddate('" + Convert.ToDateTime(ds.Tables[0].Rows[i]["date"].ToString()).ToShortDateString() + "')\">" + System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.GetDayName(Convert.ToDateTime(ds.Tables[0].Rows[i]["date"].ToString()).DayOfWeek).ToString() + "  " + Convert.ToDateTime(ds.Tables[0].Rows[i]["date"].ToString()).ToShortDateString() + "</a></li>";
        }
    }
}