using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using groupware2.Utils;

namespace groupware2.View.Controls
{
    public partial class NavBar : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e){
            if (SecurityHelper.VerifyAdmin(Page))
            {
                loginlbtn.Visible = false;
                logoutlbtn.Visible = true;
                hlList.NavigateUrl = "~/View/AdminList.aspx";
            } else
            {
                loginlbtn.Visible = true;
                logoutlbtn.Visible = false;
                hlList.NavigateUrl = "~/View/List.aspx";
            }
        }

        protected void LogoutBtn_Click(object sender, EventArgs e) {
            Session["IsAdmin"] = false;
        }
    }
}