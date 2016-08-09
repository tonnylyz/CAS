using System;
using System.Data;
using System.Web;
namespace CAS
{
    /// <summary>
    /// CAS User
    /// </summary>
    public class User
    {
        private int ID;
        public string UUID;
        public string username;
        private string password;
        private string SN;
        public string realname;
        public string mail;
        public string phone;
        public string QQ;
        public DateTime birthday;

        private string permissionString;
        public User(string username)
        {
            this.username = username;
            SqlIntegrate si = new SqlIntegrate(Utility.connStr);
            si.InitParameter(1);
            si.AddParameter("@username", SqlIntegrate.DataType.VarChar, username, 50);
            var dr = si.Reader("SELECT * FROM CAS_User WHERE username = @username");
            ID = Convert.ToInt32(dr["ID"]);
            UUID = dr["UUID"].ToString();
            password = dr["pwd"].ToString();
            realname = dr["name"].ToString();
            SN = dr["SN"].ToString();
            mail = dr["mail"].ToString();
            phone = dr["phone"].ToString();
            QQ = dr["QQ"].ToString();
            birthday = Convert.ToDateTime(dr["birthday"].ToString());
            permissionString = dr["permission"].ToString();
        }
        public static User Current
        {
            get
            {
                if (HttpContext.Current.Session["User"] != null)
                    return (User)HttpContext.Current.Session["User"];
                else
                    return null;
            }
            set
            {
                HttpContext.Current.Session["User"] = value;
            }
        }

        public enum PermissionType
        {
            BULLETIN = 0,
            CALENDAR = 1,
            FILEUPLD = 2,
            PHOTOSUB = 3,
            HOMEWORK = 4,
            TALKSUBT = 5
        }
        public int Permission(PermissionType type)
        {
            string[] permission = permissionString.Split(',');
            return int.Parse(permission[(int)type]);
        }

        public static bool IsLogin
        {
            get
            {
                return !(Current == null);
            }
        }
        private bool Verify(string password)
        {
            return (this.password == Utility.Encrypt(password));
        }
        public bool Login(string password)
        {
            if (Verify(password))
            {
                Current = this;
                return true;
            }
            else
                return false;
        }
        public void Logout()
        {
            Current = null;
        }
        public bool SetPassword(string password, string passwordNew)
        {
            if (Verify(password))
            {
                SqlIntegrate si = new SqlIntegrate(Utility.connStr);
                si.Execute("UPDATE CAS_User SET pwd = '" + Utility.Encrypt(passwordNew) + "' WHERE UUID = '" + UUID + "'");
                return true;
            }
            else
                return false;
        }
    }
}