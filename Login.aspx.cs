namespace CAS
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load()
        {
            if (Session["UUID"] != null && Request["action"] != null && Request["action"].ToString() == "logout")
            {
                Session.Abandon();
                Response.Redirect("Login.aspx");
            }
            if (Session["UUID"] != null)
                Response.Redirect("Default.aspx");
        }
    }
}