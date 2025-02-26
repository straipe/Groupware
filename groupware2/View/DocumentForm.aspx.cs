using System;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Xml.Linq;
using groupware2.Models;
using groupware2.Utils;
using StackExchange.Redis;

namespace groupware2.View
{
    public partial class DocumentForm : System.Web.UI.Page
    {
        private static readonly IDatabase _redis = RedisManager.Connection.GetDatabase();
        protected void Page_Load(object sender, EventArgs e){
            if (IsAjaxRequest()) return;
            int Id = int.Parse(Request.QueryString["Id"]);

            if (!IsPostBack) {
                using (var context = new AppDBContext())
                {
                    var document = context.Documents.FirstOrDefault(d => d.Id == Id);
                    lblAuthorName.Text = document.AuthorName;
                    lblCreatedAt.Text = document.CreatedAt.ToString("yyyy-MM-dd");
                }
                hlList.NavigateUrl = SecurityHelper.VerifyAdmin(Page) ? "AdminList.aspx" : "List.aspx";
            }
            Load_Data(Id);
        }

        protected void Load_Data(int Id)
        {
            string key = $"Document:{Id}";

            if (!_redis.HashExists(key, "title"))
            {
                Debug.WriteLine("DB ---> Redis 데이터 전송 중...");
                using (var context = new AppDBContext())
                {
                    var document = context.Documents.FirstOrDefault(d => d.Id == Id);
                    _redis.HashSet(key, "title", HttpUtility.HtmlDecode(document.Title));
                    _redis.HashSet(key, "content", HttpUtility.HtmlDecode(document.Content));
                }
            }
            txtTitle.Text = _redis.HashGet(key, "title").ToString();
            string content = _redis.HashGet(key, "content").ToString();
            string script = $"document.querySelector('#editor').innerHTML = '{content}';";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "AddContent", script, true);
        }

        [WebMethod]
        public static string SaveDocumentToRedis(string groupName, string title, string content)
        {
            string key = $"Document:{groupName}";
            _redis.HashSet(key, "title", HttpUtility.HtmlDecode(title));
            _redis.HashSet(key, "content", HttpUtility.HtmlDecode(content));
            return "문서가 임시 저장되었습니다.";
        }

        [WebMethod]
        public static string SaveDocumentToDB(string groupName, string title, string content)
        {
            string key = $"Document:{groupName}";
            int Id = int.Parse(groupName);
            using (var context = new AppDBContext())
            {
                var document = context.Documents.FirstOrDefault(d => d.Id == Id);
                document.Title = HttpUtility.HtmlEncode(title);
                document.Content = HttpUtility.HtmlEncode(content);
                context.SaveChanges();
            }

            return "문서가 정상적으로 저장되었습니다.";
        }

        private bool IsAjaxRequest()
        {
            return Request.Headers["X-Requested-With"] == "XMLHttpRequest";
        }
    }
}