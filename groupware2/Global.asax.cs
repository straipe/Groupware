using System;
using System.Web;
using groupware2.Utils;
using StackExchange.Redis;

namespace groupware2
{
    public class Global : System.Web.HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            var redis = RedisManager.Connection;
            var server = redis.GetServer("localhost", 6379);
            var db = redis.GetDatabase();
            foreach (var key in server.Keys(pattern: "Document:*"))
            {
                db.KeyDelete(key);
            }
        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            try
            {
                string queryString = HttpUtility.UrlDecode(Request.QueryString.ToString());
            } catch (HttpRequestValidationException){ 
                Response.Clear();
                Response.Write("<script>alert('URL에 허용되지 않는 문자가 포함되어 있습니다.'); window.history.back();</script>");
                Response.Flush();
                Response.SuppressContent = true;
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
        }

        protected void Application_Error(object sender, EventArgs e)
        {
            Exception ex = Server.GetLastError();

            if (ex is HttpRequestValidationException)
            {
                Server.ClearError(); // 기본 에러 페이지 방지
                string script = "<script>alert('입력 값에 허용되지 않는 문자가 포함되어 있습니다.'); window.history.back();</script>";

                Response.Clear();
                Response.ContentType = "text/html"; // 응답 형식 명확히 지정
                Response.Write(script);
                Response.Flush();
                Response.SuppressContent = true; // 불필요한 컨텐츠 방지
                HttpContext.Current.ApplicationInstance.CompleteRequest(); // 안전한 응답 종료
            }
        }

    }
}