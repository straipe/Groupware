using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using groupware2.Utils;

namespace groupware2.View.Controls
{
    public partial class SideBar : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            hlList.NavigateUrl = SecurityHelper.VerifyAdmin(Page) ? "~/View/AdminList.aspx" : "~/View/List.aspx";
        }
    }
}