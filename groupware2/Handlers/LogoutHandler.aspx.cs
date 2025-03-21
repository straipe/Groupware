using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using groupware2.Utils;

namespace groupware2.Handlers
{
    public partial class LogoutHandler : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 세션 값 변경
            Session["IsAdmin"] = false;
            Response.Redirect("~/View/List.aspx");
        }
    }
}