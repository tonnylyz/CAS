using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class Homework : System.Web.UI.Page
{
    public string back = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        string cmd = "SELECT DISTINCT date FROM CAS_Homework ORDER BY date DESC";
        SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sqlConnStr);
        DataSet ds = new DataSet();
        da.Fill(ds);
        for (var i = 0; i < 21; i++)
        {
            back = back + "<li><a onclick=\"homework_loaddate('" + Convert.ToDateTime(ds.Tables[0].Rows[i]["date"].ToString()).ToShortDateString() + "')\">" + System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.GetDayName(Convert.ToDateTime(ds.Tables[0].Rows[i]["date"].ToString()).DayOfWeek).ToString() + "  " + Convert.ToDateTime(ds.Tables[0].Rows[i]["date"].ToString()).ToShortDateString() + "</a></li>";
        }
    }
}