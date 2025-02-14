using System;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Services.Description;
using System.Web.UI;
using groupware2.Models;
using groupware2.Utils;

namespace groupware2.View
{
    public partial class DocumentForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e){
            if (!IsPostBack) {
                int Id = int.Parse(Request.QueryString["Id"]); ;
                using (var context = new AppDBContext())
                {
                    var document = context.Documents.FirstOrDefault(d => d.Id == Id);
                    lblAuthorName.Text = document.AuthorName;
                    lblCreatedAt.Text = document.CreatedAt.ToString("yyyy-MM-dd");
                }
                hlList.NavigateUrl = SecurityHelper.VerifyAdmin(Page) ? "AdminList.aspx" : "List.aspx";
            }
        }

        protected void BtnLoad_Click(object sender, EventArgs e)
        {
            int Id = int.Parse(Request.QueryString["Id"]); ;
            using (var context = new AppDBContext())
            {
                var document = context.Documents.FirstOrDefault(d => d.Id == Id);
                txtTitle.Text = document.Title;
                string script = $@"document.querySelector('#editor').innerHTML += '{ HttpUtility.HtmlDecode(document.Content).Replace("'", "\\'") }';";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "AddContent", script, true);
                ScriptHelper.ShowAlert(this, "성공", "문서를 정상적으로 로드하였습니다.", "success", "successRetrieveDocument");
            }
        }

        protected void BtnUpdate_Click(object sender, EventArgs e)
        {
            int Id = int.Parse(Request.QueryString["Id"]); ;
            using (var context = new AppDBContext())
            {
                var document = context.Documents.FirstOrDefault(d => d.Id == Id);
                document.Title = HttpUtility.HtmlEncode(txtTitle.Text); 
                document.Content= HttpUtility.HtmlEncode(HttpUtility.UrlDecode(hiddenContent.Value));
                context.SaveChanges();
                ScriptHelper.ShowAlert(this, "성공", "문서가 정상적으로 저장되었습니다.", "success", "successUpdateDocument");
            }
        }
    }
}