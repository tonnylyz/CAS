using System;

public partial class Talk : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!CAS.User.IsLogin)
            Response.Redirect("Login.aspx");
    }
}