using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;

namespace cas.Controllers
{
    public class AjaxController : Controller
    {
        public struct Result
        {
            public string Flag;
            public object Data;
        }
      
        public IActionResult Index()
        {
            return NoContent();
        }


        [HttpGet]
        public IActionResult GetBirthday()
        {
            var result = new Utility().AdapterJson(
                "SELECT DATEADD(YEAR, YEAR(GETDATE()) - YEAR(birthday), birthday) AS BIR, name INTO #temp FROM CAS_User WHERE birthday is not null ORDER BY BIR ASC;" +
                "SELECT BIR AS birthday, name FROM #temp WHERE BIR BETWEEN DATEADD(DAY, -1, GETDATE()) AND DATEADD(DAY, 30, GETDATE());" +
                "DROP TABLE #temp;");
            return new ObjectResult(result);
        }

        private bool IsLogined()
        {
            return HttpContext.Session.Get("uuid") != null;
        }
        
        [HttpPost]
        public IActionResult Login()
        {
            if (IsLogined())
                return NotFound();
            string username = HttpContext.Request.Form["username"];
            string password = HttpContext.Request.Form["password"];
            var result = new Result();
            if (HttpContext.Session.Get("error") == null)
                HttpContext.Session.SetInt32("error", 5);

            if (HttpContext.Session.GetInt32("error") <= 0)
            {
                result.Data = "系统拒绝服务，请重启浏览器后重试。";
                result.Flag = "critical";
            }
            else
            {
                if (username.Length > 20 || password.Length > 20 || password.Length < 6)
                {
                    result.Data = "用户名、密码长度不合法。";
                    result.Flag = "info";
                }
                else
                {
                    using (var conn = new SqlConnection(Startup.ConnStr))
                    {
                        using (var cmd = new SqlCommand(
                            "SELECT * FROM CAS_User WHERE username = @username AND pwd = @password", conn))
                        {

                            cmd.Parameters.Add(
                                new SqlParameter("@username", SqlDbType.NVarChar) {Value = username.ToLower()});
                            cmd.Parameters.Add(
                                new SqlParameter("@password", SqlDbType.NVarChar) {Value = Utility.Encrypt(password)});
                            conn.Open();
                            var dr = cmd.ExecuteReader();
                            if (dr.Read())
                            {
                                HttpContext.Session.SetInt32("error", 5);
                                HttpContext.Session.SetString("uuid", dr["UUID"].ToString());
                                HttpContext.Session.SetString("username", dr["username"].ToString());
                                HttpContext.Session.SetString("realname", dr["name"].ToString());
                                result.Data = "登陆成功。";
                                result.Flag = "success";
                            }
                            else
                            {
                                var error = HttpContext.Session.GetInt32("error");
                                if (error != null)
                                    HttpContext.Session.SetInt32("error", error.Value - 1);
                                result.Data = "指定的密码与存储的密码无法匹配。";
                                result.Flag = "error";
                            }
                            dr.Close();
                            dr.Dispose();
                            cmd.Dispose();
                            conn.Close();
                        }
                    }
                }
            }
            return new ObjectResult(result);
        }
        
        
        [HttpGet]
        public IActionResult Logout()
        {
            if (HttpContext.Session.Get("uuid") != null)
            {
                HttpContext.Session.Clear();
                return RedirectToPage("/Index");
            }
            return NotFound();
        }

        [HttpGet]
        public IActionResult GetBulletin(int id)
        {
            var util = new Utility();
            util.QueryParameters.Add(new SqlParameter("@ID", SqlDbType.Int) {Value = id});
            var dr = util.Reader("SELECT title, info FROM CAS_Notice WHERE ID=@ID");
            if (dr == null)
                return NotFound();
            var result = new Result
            {
                Data = new JObject
                {
                    ["title"] = dr["title"].ToString(),
                    ["cont"] = Utility.Base64Encode(dr["info"].ToString())
                },
                Flag = "success"
            };
            return new ObjectResult(result);
        }

        [HttpGet]
        public IActionResult GetEarth()
        {
            var util = new Utility();
            var dt = util.Adapter("SELECT DISTINCT university FROM CAS_User");
            var uni = (from DataRow dr in dt.Rows select dr["university"].ToString()).ToList();
            var result = new JArray();
            foreach (var u in uni)
            {
                util = new Utility();
                util.QueryParameters.Add(new SqlParameter("@uni", SqlDbType.NVarChar) {Value = u});
                dt = util.Adapter("SELECT name, UUID FROM CAS_User WHERE university=@uni");
                var stu = new JArray();
                foreach (DataRow dr in dt.Rows)
                    stu.Add(new JObject
                    {
                        ["name"] = dr["name"].ToString(),
                        ["UUID"] = dr["UUID"].ToString()
                    });
                result.Add(new JObject
                    {
                        ["university"] = u,
                        ["student"] = stu
                });
            }
            return new ObjectResult(result);
        }

        [HttpGet]
        public IActionResult GetTalk()
        {
            var util = new Utility();
            return new ObjectResult(util.AdapterJson("SELECT CAS_Talk.cont, CAS_Talk.date, CAS_User.name, CAS_User.UUID FROM CAS_Talk, CAS_User WHERE CAS_User.UUID = CAS_Talk.UUID ORDER BY CAS_Talk.date DESC"));
        }

        [HttpGet]
        public IActionResult GetCalendar()
        {
            var dt = new Utility().Adapter("SELECT name, birthday FROM CAS_User");
            var result = new JArray();
            foreach (DataRow dr in dt.Rows)
            {
                DateTime birthday;
                if (!DateTime.TryParse(dr["birthday"].ToString(), out birthday)) continue;
                result.Add(new JObject
                {
                    ["title"] = $"{dr["name"]}的生日",
                    ["startstr"] = $"{DateTime.Now.Year}-{birthday.Month}-{birthday.Day}"
                });
                result.Add(new JObject
                {
                    ["title"] = $"{dr["name"]}的生日",
                    ["startstr"] = $"{(DateTime.Now.Year + 1)}-{birthday.Month}-{birthday.Day}"
                });
            }
            return new ObjectResult(result);
        }

        [HttpGet]
        public IActionResult GetInfo()
        {
            if (!IsLogined())
                return NotFound();
            var util = new Utility();
            util.QueryParameters.Add(new SqlParameter("@uuid", SqlDbType.NVarChar) {Value = HttpContext.Session.GetString("uuid")});
            return new ObjectResult(util.QueryJson("SELECT mail, QQ, phone, birthday, university FROM CAS_User WHERE UUID=@uuid"));
        }

        [HttpPost]
        public IActionResult UpdateInfo()
        {
            if (!IsLogined())
                return NotFound();
            DateTime birthday;
            if (!DateTime.TryParse(HttpContext.Request.Form["birthday"].ToString(), out birthday)) return NotFound();
            string qq = HttpContext.Request.Form["QQ"];
            string phone = HttpContext.Request.Form["phone"];
            string mail = HttpContext.Request.Form["mail"];
            string university = HttpContext.Request.Form["university"];
            using (var conn = new SqlConnection(Startup.ConnStr))
            {
                using (var cmd =
                    new SqlCommand(
                        "UPDATE CAS_User SET QQ = @QQ, mail = @mail, phone = @phone, birthday = @birthday, university = @university WHERE UUID=@uuid",
                        conn))
                {
                    cmd.Parameters.Add(new SqlParameter("@QQ", SqlDbType.VarChar) {Value = qq});
                    cmd.Parameters.Add(new SqlParameter("@mail", SqlDbType.VarChar) {Value = mail});
                    cmd.Parameters.Add(new SqlParameter("@phone", SqlDbType.VarChar) {Value = phone});
                    cmd.Parameters.Add(new SqlParameter("@birthday", SqlDbType.Date) {Value = birthday});
                    cmd.Parameters.Add(new SqlParameter("@university", SqlDbType.VarChar) {Value = university});
                    cmd.Parameters.Add(new SqlParameter("@uuid", SqlDbType.VarChar) {Value = HttpContext.Session.GetString("uuid")});
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }
            return Ok();
        }

        [HttpPost]
        public IActionResult UpdatePassword()
        {
            if (!IsLogined())
                return NotFound();
            
            string password = HttpContext.Request.Form["password"];
            if (password.Length < 6 || password.Length > 20) return NotFound();
            
            using (var conn = new SqlConnection(Startup.ConnStr))
            {
                using (var cmd =
                    new SqlCommand(
                        "UPDATE CAS_User SET pwd=@pwd WHERE UUID=@uuid",
                        conn))
                {
                    cmd.Parameters.Add(new SqlParameter("@pwd", SqlDbType.VarChar) {Value = Utility.Encrypt(password)});
                    cmd.Parameters.Add(new SqlParameter("@uuid", SqlDbType.VarChar) {Value = HttpContext.Session.GetString("uuid")});
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }
            
            return Ok();
        }

        [HttpGet]
        public IActionResult GetAddressbook(int? id)
        {
            if (!IsLogined())
                return NotFound();
            if (id == null)
            {
                return new ObjectResult(
                    new Utility().AdapterJson(
                        "SELECT ID, UUID, name, username FROM CAS_User ORDER BY name"
                        )
                    );
            }
            else
            {
                var util = new Utility();
                util.QueryParameters.Add(new SqlParameter("@id", SqlDbType.Int) { Value = id});
                return new ObjectResult(util.QueryJson("SELECT username, name, mail, QQ, phone, birthday, university FROM CAS_User WHERE ID=@id"));
            }
        }
    }
}