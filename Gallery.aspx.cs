using System;
using System.Data;

public partial class Gallery : System.Web.UI.Page
{
	public string[] onPage = new string[2];
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!CAS.User.IsLogin)
            Response.Redirect("Login.aspx");
        CAS.SqlIntegrate si = new CAS.SqlIntegrate(CAS.Utility.connStr);
        DataTable dt = si.Adapter("SELECT CAS_Photo.*, CAS_User.* FROM CAS_Photo, CAS_User WHERE CAS_User.UUID = CAS_Photo.UUID ORDER BY CAS_Photo.ID DESC");
        for (int i = 0; i < dt.Rows.Count; i++)
            onPage[0] += "<li class=\"mix col-sm-3" + (Convert.IsDBNull(dt.Rows[i]["folder"]) ? "" : (" " + dt.Rows[i]["folder"].ToString())) + "\" data-name=\"" + dt.Rows[i]["title"].ToString() + "\">"
                            +"<a class=\"thumbnail swipebox\" href=\"Photo/" +dt.Rows[i]["GUID"].ToString() + ".jpg\" title=\"" + dt.Rows[i]["title"].ToString() + "\">" 
                               + "<img src=\"Photo/" + dt.Rows[i]["GUID"].ToString() + "_thumb.jpg\">" 
                               + "<div class=\"caption\">" 
                                  + "<h4>" + dt.Rows[i]["title"].ToString() + "</h4>" 
                               + "</div>" 
                            + "</a>" 
                        + "</li>";
        dt = si.Adapter("SELECT DISTINCT [folder] FROM CAS_Photo");
        for (int i = 0; i < dt.Rows.Count; i++)
            if (!Convert.IsDBNull(dt.Rows[i]["folder"]))
                onPage[1] += "<li class=\"filter\" data-filter=\" ." + dt.Rows[i]["folder"].ToString() + "\"><a>" + dt.Rows[i]["folder"].ToString() + "</a></li>";
    }
}