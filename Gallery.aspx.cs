using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class Gallery : System.Web.UI.Page
{
    public void loadPhoto()
    {
        string cmd = "SELECT CAS_Photo.*, CAS_User.* FROM CAS_Photo, CAS_User WHERE CAS_User.UUID = CAS_Photo.UUID AND CAS_Photo.[classnum] = '" + Session["classnum"].ToString() + "'";
        SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sqlConnStr);
        DataSet ds = new DataSet();
        da.Fill(ds);
        for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            onpage[0] += "<li class=\"mix col-sm-3" + (Convert.IsDBNull(ds.Tables[0].Rows[i]["folder"]) ? "" : (" " + ds.Tables[0].Rows[i]["folder"].ToString())) + "\" data-name='" + ds.Tables[0].Rows[i]["title"].ToString() + "'><a class='thumbnail swipebox' href='Photo/" + ds.Tables[0].Rows[i]["GUID"].ToString() + ".jpg' title='" + ds.Tables[0].Rows[i]["title"].ToString() + "'><img src='Photo/" + ds.Tables[0].Rows[i]["GUID"].ToString() + "_thumb.jpg'><div class='caption'><h4>" + ds.Tables[0].Rows[i]["title"].ToString() + "</h4></div></a></li>";
        }
    }

    public void loadFolder()
    {
        string cmd = "SELECT DISTINCT [folder] FROM CAS_Photo WHERE [classnum] = '" + Session["classnum"].ToString() + "'";
        SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sqlConnStr);
        DataSet ds = new DataSet();
        da.Fill(ds);
        for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            if (!Convert.IsDBNull(ds.Tables[0].Rows[i]["folder"]))
                onpage[1] += "<li class=\"filter\" data-filter=\" ." + ds.Tables[0].Rows[i]["folder"].ToString() + "\"><a>" + ds.Tables[0].Rows[i]["folder"].ToString() + "</a></li>";
        }
    }

	public string[] onpage = new string[2];
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (Session["UUID"] == null)
            Response.Redirect("Login.aspx");
        loadPhoto();
        loadFolder();
    }
}