using System;
using System.Data;

public partial class Bulletin : System.Web.UI.Page
{
    public string[] onPage = new string[4];
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!CAS.User.IsLogin)
            Response.Redirect("Login.aspx");

        CAS.SqlIntegrate si = new CAS.SqlIntegrate(CAS.Utility.connStr);
        if (Request["ID"] != null)
        {
            DataRow dr = si.Reader("SELECT * FROM CAS_Notice WHERE [GUID] = '" + Guid.Parse(Request["ID"]).ToString().ToUpper() + "'");
            onPage[1] = dr["title"].ToString();
            onPage[2] = dr["content"].ToString();
            onPage[3] = dr["date"].ToString();
        }
        DataTable dt = si.Adapter("SELECT * FROM CAS_Notice ORDER BY [date] DESC");
        for (int i = 0; i < dt.Rows.Count && i < 20; i++)
            onPage[0] += "<li data-id=\"" + dt.Rows[i]["GUID"].ToString() + "\"><a onclick=\"bulletinShowNotice(this);\">" + dt.Rows[i]["title"].ToString() + "</a></li>";
        
    }
}