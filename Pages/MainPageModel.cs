using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace cas.Pages
{
    public class MainPageModel : PageModel
    {
        public void OnGet()
        {
            if (HttpContext.Session.Get("uuid") != null)
            {
                ViewData["login"] = true;
                ViewData["avatar"] = $"photo/{HttpContext.Session.GetString("uuid")}.jpg";
                ViewData["username"] = HttpContext.Session.GetString("realname");
            }
            else
            {
                ViewData["login"] = null;
                ViewData["avatar"] = string.Empty;
                ViewData["username"] = string.Empty;
            }
        }
    }
}