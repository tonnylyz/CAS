using System;
namespace CAS
{
    public partial class Gallery : System.Web.UI.Page
    {
        public string[] onpage = new string[2];
        protected void Page_Load()
        {
            SqlIntegrate si = new SqlIntegrate(Utility.sqlConnStr);
            string[,] photo = si.Adapter("SELECT CAS_Photo.*, CAS_User.* FROM CAS_Photo, CAS_User WHERE CAS_User.UUID = CAS_Photo.UUID"
                , new string[] { "folder", "title", "GUID" , "date" });
            for (int i = 0; i < photo.GetLength(0); i++)
                if (Convert.ToDateTime(photo[i,3]) < new DateTime(2015,4,25))
                    onpage[0] += "<li class=\"mix col-sm-3" + (Convert.IsDBNull(photo[i, 0]) ? "" : (" " + photo[i, 0])) + "\" data-name='" + photo[i, 1] + "'><a class='thumbnail swipebox' href='http://cass.oss-cn-shenzhen.aliyuncs.com/photo/" + photo[i, 2] + ".jpg' title='" + photo[i, 1] + "'><img src='http://cass.oss-cn-shenzhen.aliyuncs.com/photo/" + photo[i, 2] + "_thumb.jpg'><div class='caption'><h4>" + photo[i, 1] + "</h4></div></a></li>";
                else 
                    onpage[0] += "<li class=\"mix col-sm-3" + (Convert.IsDBNull(photo[i, 0]) ? "" : (" " + photo[i, 0])) + "\" data-name='" + photo[i, 1] + "'><a class='thumbnail swipebox' href='photo/" + photo[i, 2] + ".jpg' title='" + photo[i, 1] + "'><img src='photo/" + photo[i, 2] + "_thumb.jpg'><div class='caption'><h4>" + photo[i, 1] + "</h4></div></a></li>";

            string[,] folder = si.Adapter("SELECT DISTINCT folder FROM CAS_Photo"
                , new string[] { "folder" });
            for (int i = 0; i < folder.GetLength(0); i++)
                onpage[1] += "<li class=\"filter\" data-filter=\" ." + folder[i, 0] + "\"><a>" + folder[i, 0] + "</a></li>";
        }
    }
}