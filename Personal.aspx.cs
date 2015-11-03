namespace CAS
{
    public partial class Personal : System.Web.UI.Page
    {
        protected void Page_Load()
        {
            if (Session["UUID"] == null)
                Response.Redirect("Login.aspx");
        }
    }
}