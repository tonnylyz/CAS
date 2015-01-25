using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
	public string getHomework(int subject, DateTime dt)
    {
        string back = "";
        if (Convert.ToInt32(CAS.sqlExecute("SELECT COUNT(*) FROM CAS_Homework WHERE [date] ='" + CAS.dateToString(dt) + "' AND [subject] =" + subject + " AND [classnum] = '" + Session["classnum"].ToString() + "'")) != 0)
        {
            back = "<li>" + CAS.subject[subject] + "<ul class='nav'>";
            string cmd = "SELECT * FROM CAS_Homework WHERE [date] = '" + CAS.dateToString(dt) + "' AND [subject] =" + subject + " AND [classnum] = '" + Session["classnum"].ToString() + "'";
            SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sqlConnStr);
            DataSet ds = new DataSet();
            da.Fill(ds);
            for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                back += "<li>" + ds.Tables[0].Rows[i]["info"].ToString() + "</li>";
            }
            back += "</ul><li>";
        }
        return back;
    }

    public string getFile(int subject, DateTime dt)
    {
        string back = "";
        if (Convert.ToInt32(CAS.sqlExecute("SELECT COUNT(*) FROM CAS_File WHERE [date] ='" + CAS.dateToString(dt) + "' AND [subject] =" + subject + " AND [classnum] = '" + Session["classnum"].ToString() + "'")) != 0)
        {
            back = "<li>" + CAS.subject[subject] + "<ul class='nav'>";
            string cmd = "SELECT * FROM CAS_File WHERE [date] = '" + CAS.dateToString(dt) + "' AND [subject] =" + subject + " AND [classnum] = '" + Session["classnum"].ToString() + "'";
            SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sqlConnStr);
            DataSet ds = new DataSet();
            da.Fill(ds);
            for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                back = back + "<li><a href=\"file.ashx?file=" + ds.Tables[0].Rows[i]["GUID"].ToString() + "\">" + ds.Tables[0].Rows[i]["filename"].ToString() + "</a></li>";
            }
            back = back + "</ul><li>";
        }
        return back;
    }

	public string getFileList()
	{
        string back = "<ul class='nav bs-sidenav'>";
        DateTime dt;
        if (DateTime.TryParse(CAS.sqlExecute("SELECT TOP 1 [date] FROM CAS_File WHERE [classnum] = '" + Session["classnum"].ToString() + "' ORDER BY [date] DESC"), out dt)) 
            for (int sub = 0; sub < 9; sub++)
                back += getFile(sub, dt);
        else
            back += "<li>暂无</li>";
        back += "</ul>";
        return back;
	}
	
	public string getHomeworkList()
	{
        string back = "<ul class='nav bs-sidenav'>";
        DateTime dt;
        if (DateTime.TryParse(CAS.sqlExecute("SELECT TOP 1 [date] FROM CAS_Homework WHERE [classnum] = '" + Session["classnum"].ToString() + "' ORDER BY [date] DESC"), out dt))
            for (int sub = 0; sub < 9; sub++)
                back += getHomework(sub, dt);
        else
            back += "<li>暂无</li>";
        back += "</ul>";
		return back;
	}
	
	public string getNoticeList()
	{
		string back = "<ul class='nav bs-sidenav'>";
		string cmd;
        if (Convert.ToInt32(CAS.sqlExecute("SELECT COUNT(*) FROM CAS_Notice WHERE [classnum] = '" + Session["classnum"].ToString() + "'")) >= 7)
            cmd = "SELECT TOP 7 * FROM CAS_Notice WHERE [classnum] = '" + Session["classnum"].ToString() + "' ORDER BY [date] DESC";
        else
            cmd = "SELECT * FROM CAS_Notice WHERE [classnum] = '" + Session["classnum"].ToString() + "' ORDER BY [date] DESC";
		SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sqlConnStr);
		DataSet ds = new DataSet();
		da.Fill(ds);
		for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
		{
			back = back + "<li><a href='Bulletin.aspx?ID=" + ds.Tables[0].Rows[i]["GUID"].ToString() + "'>" + ds.Tables[0].Rows[i]["title"].ToString() + "</a></li>";
		}
        back = back + "</ul>";
		return back;
	}
	
	public string[] onpage = new string[5];
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UUID"] == null)
            Response.Redirect("Login.aspx");
		onpage[0] = getNoticeList();
		onpage[1] = getHomeworkList();
		onpage[2] = getFileList();
        DateTime dt;
        if (DateTime.TryParse(CAS.sqlExecute("SELECT TOP 1 [date] FROM CAS_Homework WHERE [classnum] = '" + Session["classnum"].ToString() + "' ORDER BY [date] DESC"), out dt))
            onpage[3] = dt.ToShortDateString();
        else
            onpage[3] += "";
        if (DateTime.TryParse(CAS.sqlExecute("SELECT TOP 1 [date] FROM CAS_File WHERE [classnum] = '" + Session["classnum"].ToString() + "' ORDER BY [date] DESC"), out dt))
            onpage[4] = dt.ToShortDateString();
        else
            onpage[4] += "";
    }
}