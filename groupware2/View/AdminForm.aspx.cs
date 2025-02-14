using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using groupware2.Utils;

namespace groupware2.View
{
    public partial class AdminForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.HttpMethod == "POST")
            {
                // 전송된 PIN 번호 받기
                string pin = Request.Form["pin"];

                if (SecurityHelper.VerifyPIN(pin))
                {
                    Session["IsAdmin"] = true;
                    Response.ContentType = "application/json";
                    Response.Write("{\"status\": \"success\", \"message\": \"관리자 로그인 성공!\"}");
                }
                else
                {
                    Response.ContentType = "application/json";
                    Response.Write("{\"status\": \"error\", \"message\": \"잘못된 PIN입니다. 다시 시도하세요.\"}");
                }

                Response.End();
            }
        }

    }
}