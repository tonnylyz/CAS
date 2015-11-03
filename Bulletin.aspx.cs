using System;
namespace CAS
{
    public partial class Bulletin : System.Web.UI.Page
    {
        public string listtext;
        public string[] content;
        protected void Page_Load()
        {
            SqlIntegrate si = new SqlIntegrate(Utility.sqlConnStr);
            string[,] list = si.Adapter("SELECT * FROM CAS_Notice WHERE date BETWEEN '" + DateTime.Now.AddDays(-1000).ToShortDateString() + "' AND '" + DateTime.Now.AddDays(1).ToShortDateString() + "' ORDER BY ID DESC"
                , new string[] { "GUID", "title" });
            for (int i = 0; i < list.GetLength(0); i++)
                listtext += "<li data-id='" + list[i,0] + "'><a onclick=\"bulletinShowNotice(this);\">" + list[i,1] + "</a></li>";
            int nid = 0;
            if (Request["ID"] != null && int.TryParse(Request["ID"].ToString(), out nid))
                content = si.Query("SELECT * FROM CAS_Notice WHERE ID = " + nid, new string[] { "title", "info" });
        }
    }
}