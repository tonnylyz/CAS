namespace CAS
{
    public partial class Addressbook : System.Web.UI.Page
    {
        protected void Page_Load()
        {
            if (Session["UUID"] == null)
                Response.Redirect("Default.aspx");
        }
    }
}