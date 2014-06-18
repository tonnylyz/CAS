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
	public string Gethomework(string subject, DateTime dt)
    {
        string back = "";
        if (Convert.ToInt32(CAS.sql_execute("SELECT COUNT(*) FROM CAS_Homework WHERE date ='" + dt.ToShortDateString() + "' AND subject ='" + subject + "'")) != 0)
        {
            switch (subject)
            {
                case "chi": back = "<li>语文<ul class='nav'>"; break;
                case "mat": back = "<li>数学<ul class='nav'>"; break;
                case "eng": back = "<li>英语<ul class='nav'>"; break;
                case "phy": back = "<li>物理<ul class='nav'>"; break;
                case "che": back = "<li>化学<ul class='nav'>"; break;
                case "bio": back = "<li>生物<ul class='nav'>"; break;
                case "pol": back = "<li>政治<ul class='nav'>"; break;
                case "his": back = "<li>历史<ul class='nav'>"; break;
                case "geo": back = "<li>地理<ul class='nav'>"; break;
            }
            string cmd = "SELECT * FROM CAS_Homework WHERE date = '" + dt.ToShortDateString() + "' AND subject ='" + subject + "'";
            SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sql_connstr);
            DataSet ds = new DataSet();
            da.Fill(ds);
            for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                back = back + "<li>" + ds.Tables[0].Rows[i]["info"].ToString() + "</li>";
            }
            back = back + "</ul><li>";
        }
        return back;
    }

    public string Getfilelist(string subject, DateTime dt)
    {
        string back = "";
        if (Convert.ToInt32(CAS.sql_execute("SELECT COUNT(*) FROM CAS_File WHERE date ='" + dt.ToShortDateString() + "' AND subject ='" + subject + "'")) != 0)
        {

            back = "<li>"+subject+"<ul class='nav'>";
            string cmd = "SELECT * FROM CAS_File WHERE date = '" + dt.ToShortDateString() + "' AND subject ='" + subject + "'";
            SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sql_connstr);
            DataSet ds = new DataSet();
            da.Fill(ds);
            for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                back = back + "<li><a href=\"ajax.ashx?action=getfile&file=" + ds.Tables[0].Rows[i]["path"].ToString() + "\">" + ds.Tables[0].Rows[i]["filename"].ToString() + "</a></li>";
            }
            back = back + "</ul><li>";
        }
        return back;
    }

	public string getfilelist()
	{
        string back = "<ul class='nav bs-sidenav'>";
        DateTime dt = Convert.ToDateTime(CAS.sql_execute("select date from CAS_File ORDER BY ID desc"));
		string[] subject = new string[] { "语文", "数学", "英语", "物理", "化学", "生物", "政治", "历史", "地理" };
		foreach (string sub in subject)
		{
			back = back + Getfilelist(sub, dt);
		}
        back = back + "</ul>";
		return back;
	}
	
	public string gethomeworklist()
	{
        string back = "<ul class='nav bs-sidenav'>";
        DateTime dt = Convert.ToDateTime(CAS.sql_execute("select date from CAS_Homework ORDER BY ID desc"));
		string[] subject = new string[] { "chi", "mat", "eng", "phy", "che", "bio", "pol", "his", "geo" };
		foreach (string sub in subject)
		{
			back = back + Gethomework(sub, dt);
        }
        back = back + "</ul>";
		return back;
	}
	
	public string getnoticelist()
	{
		string back = "<ul class='nav bs-sidenav'>";
		string cmd = "SELECT TOP 7 * FROM CAS_Notice ORDER BY ID DESC";
		SqlDataAdapter da = new SqlDataAdapter(cmd, CAS.sql_connstr);
		DataSet ds = new DataSet();
		da.Fill(ds);
		for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
		{
			back = back + "<li><a href='Bulletin.aspx?ID=" + ds.Tables[0].Rows[i]["ID"].ToString() + "'>" + ds.Tables[0].Rows[i]["title"].ToString() + "</a></li>";
		}
        back = back + "</ul>";
		return back;
	}
	
	public string[] onpage = new string[5];
    protected void Page_Load(object sender, EventArgs e)
    {
		onpage[0] = getnoticelist();
		onpage[1] = gethomeworklist();
		onpage[2] = getfilelist();
		onpage[3] = Convert.ToDateTime(CAS.sql_execute("select date from CAS_Homework ORDER BY ID desc")).ToShortDateString();
		onpage[4] = Convert.ToDateTime(CAS.sql_execute("select date from CAS_File ORDER BY ID desc")).ToShortDateString();
    }
}