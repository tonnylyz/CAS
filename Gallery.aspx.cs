using System;

public partial class Gallery : System.Web.UI.Page
{
    public string[] OnPage = new string[2];
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!CAS.User.IsLogin)
            Response.Redirect("Login.aspx");
        var si = new CAS.SqlIntegrate(CAS.Utility.connStr);
        var dt = si.Adapter("SELECT CAS_Photo.*, CAS_User.* FROM CAS_Photo, CAS_User WHERE CAS_User.UUID = CAS_Photo.UUID ORDER BY CAS_Photo.ID DESC");
        for (var i = 0; i < dt.Rows.Count; i++)
            OnPage[0] += "<li class=\"mix col-sm-3" + (Convert.IsDBNull(dt.Rows[i]["folder"]) ? "" : " " + dt.Rows[i]["folder"]) + "\" data-name=\"" + dt.Rows[i]["title"] + "\">" + 
                            "<a class=\"thumbnail swipebox\" href=\"Photo/" + dt.Rows[i]["GUID"] + ".jpg\" title=\"" + dt.Rows[i]["title"] + "\">" + 
                                "<img src=\"Photo/" + dt.Rows[i]["GUID"] + "_thumb.jpg\">" + 
                                "<div class=\"caption\">" + 
                                    "<h4>" + dt.Rows[i]["title"] + "</h4>" + 
                                "</div>" + 
                            "</a>" + 
                        "</li>";
        dt = si.Adapter("SELECT DISTINCT [folder] FROM CAS_Photo");
        for (var i = 0; i < dt.Rows.Count; i++)
            if (!Convert.IsDBNull(dt.Rows[i]["folder"]))
                OnPage[1] += "<li class=\"filter\" data-filter=\" ." + dt.Rows[i]["folder"] + "\">" +
                                "<a>" + dt.Rows[i]["folder"] + "</a>" +
                             "</li>";
    }
}