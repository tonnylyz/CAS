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
	public string back = "";
    protected void Page_Load(object sender, EventArgs e)
    {
		string cmd = "SELECT CAS_Photo.*, CAS_User.* FROM CAS_Photo, CAS_User WHERE CAS_User.UUID = CAS_Photo.UUID";
		SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sqlConnStr);
		DataSet ds = new DataSet();
		da.Fill(ds);
		for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
		{
			back = back + "<li class='mix col-md-3 " + ds.Tables[0].Rows[i]["folder"].ToString() + "' data-name='" + ds.Tables[0].Rows[i]["title"].ToString() + "'><a class='thumbnail swipebox' href='Photo/" + ds.Tables[0].Rows[i]["GUID"].ToString() + ".jpg' title='"+ds.Tables[0].Rows[i]["title"].ToString()+"'><img src='Photo/"+ds.Tables[0].Rows[i]["GUID"].ToString()+"_thumb.jpg'><div class='caption'><h4>"+ds.Tables[0].Rows[i]["title"].ToString()+" <small>"+ds.Tables[0].Rows[i]["name"].ToString()+" "+Convert.ToDateTime(ds.Tables[0].Rows[i]["date"].ToString()).ToShortDateString()+"</small></h4></div></a></li>";
		}
    }
}