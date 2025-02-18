using System;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using groupware2.Models;
using groupware2.Utils;
using StackExchange.Redis;

namespace groupware2.View
{
    public partial class DocumentForm : System.Web.UI.Page
    {
        private readonly IDatabase _redis = RedisManager.Connection.GetDatabase();
        protected void Page_Load(object sender, EventArgs e){
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

        protected void BtnUpdate_Click(object sender, EventArgs e)
        {
            int Id = int.Parse(Request.QueryString["Id"]);
            string key = $"Document:{Id}";
            using (var context = new AppDBContext())
            {
                var document = context.Documents.FirstOrDefault(d => d.Id == Id);
                string title = _redis.HashGet(key, "title").ToString();
                document.Title = HttpUtility.HtmlEncode(title);
                string content = _redis.HashGet(key, "content").ToString();
                document.Content= HttpUtility.HtmlEncode(content);
                context.SaveChanges();
                ScriptHelper.ShowAlert(this, "성공", "문서가 정상적으로 저장되었습니다.", "success", "successUpdateDocument");
            }
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
                    _redis.HashSet(key, "title", document.Title);
                    _redis.HashSet(key, "content", document.Content);
                }
            }
            txtTitle.Text = _redis.HashGet(key, "title");
            string content = HttpUtility.HtmlDecode(_redis.HashGet(key, "content").ToString().Replace("'", "\\'"));
            string script = $"document.querySelector('#editor').innerHTML = '{content}';";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "AddContent", script, true);
        }
    }
}