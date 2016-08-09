using System;
using System.Data;

public partial class Bulletin : System.Web.UI.Page
{
    public string[] OnPage = new string[4];
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!CAS.User.IsLogin)
            Response.Redirect("Login.aspx");
        CAS.SqlIntegrate si = new CAS.SqlIntegrate(CAS.Utility.connStr);
        if (Request["ID"] != null)
        {
            var dr = si.Reader("SELECT * FROM CAS_Notice WHERE [GUID] = '" + Guid.Parse(Request["ID"]).ToString().ToUpper() + "'");
            OnPage[1] = dr["title"].ToString();
            OnPage[2] = dr["content"].ToString();
            OnPage[3] = dr["date"].ToString();
        }
        var dt = si.Adapter("SELECT * FROM CAS_Notice ORDER BY [date] DESC");
        for (var i = 0; i < dt.Rows.Count && i < 20; i++)
            OnPage[0] += "<li data-id=\"" + dt.Rows[i]["GUID"] + "\">" +
                            "<a onclick=\"bulletinShowNotice(this);\">" + dt.Rows[i]["title"] + "</a>" +
                         "</li>";
    }
}